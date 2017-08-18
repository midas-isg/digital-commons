#!/usr/bin/env python3
import http.client
from collections import defaultdict

import conf
import psycopg2
import xmltodict

host = 'raw.githubusercontent.com'
resource_path = "/ApolloDev/apollo-sv/master/src/ontology/apollo-sv.owl"

rdf_about = '@rdf:about'
IDCS_IRI = 'http://purl.obolibrary.org/obo/APOLLO_SV_00000086'

about2class = {}
about2kids = defaultdict(list)

def main():
    _load_owl_from_github()


def _load_owl_from_github():
    response = _get_response()
    print(response.status)
    if not response.closed:
        control_measures = []
        raw = response.read()
        owl = raw.decode("utf-8")
        # print((owl))
        dic = xmltodict.parse(owl)
        rdf = dic['rdf:RDF']
        owl_classes = rdf['owl:Class']
        for owl_class in owl_classes:
            about = owl_class.get(rdf_about)
            about2class[about] = owl_class
            subclass_of = owl_class.get('rdfs:subClassOf')
            supers = _to_supers(subclass_of)

            for super_class in supers:
                if super_class is not None:
                    resource = super_class.get('@rdf:resource')
                    about2kids[resource].append(about)
                    if resource == IDCS_IRI:
                        control_measures.append(owl_class)
        _fill_db(control_measures)
        # _recursive_print(control_measures, '-')


def _fill_db(control_measures):
    try:
        conn, cursor = _connect()

        _create_table_owl(conn, cursor)
        _load_idcs(conn, cursor, control_measures)

    except Exception as e:
        print("Uh oh:", e)
        raise e


def _connect():
    conn = psycopg2.connect(conf.connect_str)
    cursor = conn.cursor()
    cursor.execute("SET SCHEMA '" + conf.schema_name + "'")
    return conn, cursor


def _create_table_owl(conn, cursor):
    max_pg_varchar = 10485760

    cursor.execute( """CREATE TABLE owl_class (
      label VARCHAR(512),
      iri VARCHAR(1024),
      ancestors  VARCHAR(""" + str(max_pg_varchar) + """), 

      id BIGSERIAL PRIMARY KEY
    );""")
    conn.commit()


def _to_supers(subclass_of):
    supers = []
    kind = type(subclass_of)
    if kind is None:
        pass
    elif kind is not list:
        supers.append(subclass_of)
    else:
        supers = subclass_of
    return supers


def _get_response():
    conn = http.client.HTTPSConnection(host)
    conn.request("GET", resource_path)
    response = conn.getresponse()
    return response


def _recursive_print(classes, indent):
    for c in classes:
        if c is not None:
            about = c.get(rdf_about)
            print(indent, c['rdfs:label']['#text'], about)
            kid_iris = about2kids[about]
            kids = [about2class[k] for k in kid_iris]
            _recursive_print(kids, ' ' + indent)


def _load_idcs(conn, cursor, classes):
    _load_owl_recursive(cursor, classes, 'http://purl.obolibrary.org/obo/IAO_0000104')
    conn.commit()


def _load_owl_recursive(cursor, classes, ancestors):
    for c in classes:
        if c is not None:
            about = c.get(rdf_about)
            label = c['rdfs:label']['#text']
            new_ancestors = ancestors + ',' + about
            cursor.execute('insert into owl_class ' + _to_sql_values([label, about, new_ancestors]))
            kid_iris = about2kids[about]
            kids = [about2class[k] for k in kid_iris]
            _load_owl_recursive(cursor, kids, new_ancestors)


def quote(txt):
    return "'" + txt + "'"


def _to_sql_values(strings):
    values = ",".join(map(quote, strings))
    return 'VALUES(' + values + ')'


main()