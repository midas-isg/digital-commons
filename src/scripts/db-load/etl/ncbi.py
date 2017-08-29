#!/usr/bin/env python3

import csv
import queue

import conf
import psycopg2

in_dialect = 'bar'
out_dialect = 'csv'
csv.register_dialect(in_dialect, delimiter='|', quoting=csv.QUOTE_NONE)
csv.register_dialect(out_dialect, delimiter=',', quoting=csv.QUOTE_ALL, quotechar="'")
max_pg_varchar = 10485760


def main():
    try:
        conn, cursor = _connect(conf.schema_name)

        _create_table_node(conn, cursor)
        _load_nodes(conn, cursor)
        _index_node(conn, cursor)
        _modify_node(conn, cursor)

        _create_table_name(conn, cursor)
        _load_names(conn, cursor)
        _index_name(conn, cursor)

        _create_view_ncbi(conn, cursor)
        _view_ncbi(conn, cursor)
    except Exception as e:
        print("Uh oh:", e)
        raise e


def _index_node(conn, cursor):
    print('Creating indexes for table node ...')
    cursor.execute("""CREATE INDEX ON node ((id));""")
    cursor.execute("""CREATE INDEX ON node ((parent_id));""")
    print('Done')
    conn.commit()


def _index_name(conn, cursor):
    print('Creating indexes for table name ...')
    cursor.execute("""CREATE INDEX ON name ((name));""")
    print('Done')
    conn.commit()


def _iter_row(cursor, size=100):
    while True:
        rows = cursor.fetchmany(size)
        if not rows:
            break
        for row in rows:
            yield row


def _view_ncbi(conn, cursor):
    id2child_ids = {}
    id2node = {}
    root_ids = set()
    nonroot_ids = set()

    cursor.execute("SELECT * FROM ncbi LIMIT 10")
    print("rowcount: ", cursor.rowcount)

    for row in _iter_row(cursor):
        id, pid, name, div = row
        id2node[id] = row
        if id == pid:
            root_ids.add(id)
        else:
            child_ids = id2child_ids.get(pid, [])
            child_ids.append(id)
            id2child_ids[pid] = child_ids
            nonroot_ids.add(id)
        #print(row)
    ids = id2node.keys() | set()
    print(ids)
    print(nonroot_ids)
    calc_root_ids = ids.difference(nonroot_ids)
    print(root_ids, calc_root_ids)
    print(id2child_ids)


def _load_nodes(conn, cursor):
    out_filename = 'nodes.dmp.csv'
    with open('nodes.dmp', 'r') as fin, open(out_filename, 'w') as fout:
        csv_writer = csv.writer(fout, out_dialect)
        csv_reader = csv.reader(fin, in_dialect)
        for columns in csv_reader:
            csv_writer.writerow([c.replace('\t', '') for c in columns][:12])
            #break
    with open(out_filename, 'r') as fin:
        for line in fin:
            values = _to_sql_values(line)
            print(values)
            cursor.execute('insert into node ' + values)
    conn.commit()
    _fix_node(cursor)


def _fix_node(conn, cursor):
    cursor.execute('UPDATE node SET parent_id = null WHERE id = 1')
    conn.commit()


def _modify_node(conn, cursor):
    cursor.execute('alter table node add COLUMN path VARCHAR(' + str(max_pg_varchar) + ')')
    cursor.execute('alter table node add COLUMN leaf boolean DEFAULT TRUE')
    # _update_node_path(cursor)
    cursor.execute("""CREATE INDEX ON node ((path));""")
    conn.commit()


def _update_node_path(cursor):
    id2path = {}
    q = queue.Queue()
    q.put(1)
    cursor.execute("update node SET path = '1' where id = 1")
    _update_node_not_leaf(cursor, 1)
    id2path[1] = '1'
    level = 1
    q.put(0)
    kids = 0
    leaves = []
    while not q.empty(): # and level < 4:
        pid = q.get()
        if not q.empty():
            if kids != 0:
                q.put(0)
            print('No kids:', leaves)
            print('level =', level, 'has kids =', kids, ' @ len(q)=', q.qsize())
            kids = 0
            level += 1
            continue
        ppath = id2path[pid]
        cursor.execute('select id, parent_id from node where parent_id = ' + str(pid))
        rows = cursor.fetchall()
        if rows:
            _update_node_not_leaf(cursor, pid)
            kid = len(rows)
            print('\t', 'id =', pid, 'has children =', kid, ' @ len(q)=', q.qsize())
            kids += kid
        else:
            leaves.append(pid)
        for row in rows:
            id, _ = row
            id_str = str(id)
            path = ppath + '/' + id_str
            cursor.execute("update node SET path = '" + path + "' where id = " + id_str)
            id2path[id] = path
            #print(id)
            q.put(id)


def _update_node_not_leaf(cursor, id):
    cursor.execute("update node SET leaf = FALSE where id = " + str(id))


def _load_names(conn, cursor):
    in_filename = 'names.dmp'
    out_filename = in_filename + '.csv'
    with open(in_filename, 'r') as fin, open(out_filename, 'w') as fout:
        csv_writer = csv.writer(fout, out_dialect)
        csv_reader = csv.reader(fin, in_dialect)
        for columns in csv_reader:
            csv_writer.writerow([c.replace("'\t", '').replace("\t'", '').replace('\t', '') for c in columns][:4])
            #break
    with open(out_filename, 'r') as fin:
        for line in fin:
            values = _to_sql_values(line)
            print(values)
            cursor.execute('insert into name ' + values)
    conn.commit()


def _create_table_name(conn, cursor):
    cursor.execute( """CREATE TABLE name (
      tax_id BIGINT,
      name VARCHAR(256),
      unique_name VARCHAR(256),
      name_class VARCHAR(1024),

      id BIGSERIAL PRIMARY KEY
    );""")
    conn.commit()


def _to_sql_values(line):
    values = line.replace("''", 'null')
    return 'VALUES(' + values + ')'


def _connect(schema):
    conn = psycopg2.connect(conf.connect_str)
    cursor = conn.cursor()
    cursor.execute("SET SCHEMA '" + schema + "'")
    return conn, cursor


def _create_table_node(conn, cursor):
    cursor.execute( """CREATE TABLE node (
      id BIGSERIAL PRIMARY KEY,
      parent_id BIGINT,
      rank VARCHAR(64),
      div_id VARCHAR(64),
      inherited_div_flag SMALLINT,
      gc_id BIGINT,
      inherited_gc_flag SMALLINT,
      mgc_id BIGINT,
      inherited_mgc_flag SMALLINT,
      gb_hidden_flag SMALLINT,
      hidden_subtree_root_flag SMALLINT,
      comments VARCHAR(1024),

      path
    );""")
    conn.commit()


def _create_view_ncbi(conn, cursor):
    cursor.execute( """CREATE VIEW ncbi AS
        SELECT o.id, o.parent_id, a.name, o.div_id, o.path, o.leaf
        FROM node o, name a
        WHERE a.name_class = 'scientific name'
            and a.tax_id = o.id
    """)
    conn.commit()


main()
