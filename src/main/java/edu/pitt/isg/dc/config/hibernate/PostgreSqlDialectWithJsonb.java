package edu.pitt.isg.dc.config.hibernate;


import org.hibernate.dialect.PostgreSQL94Dialect;

import java.sql.Types;

public class PostgreSqlDialectWithJsonb extends PostgreSQL94Dialect {
    public PostgreSqlDialectWithJsonb() {
        super();
        registerColumnType(Types.JAVA_OBJECT, JsonbType.NAME);
    }
}