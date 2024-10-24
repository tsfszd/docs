using System.Data;
using System;

namespace nexelus.oraclehelper
{
    [Flags]
    public enum ResultType
    {
        Default = CommandBehavior.Default,
        SingleRow = CommandBehavior.SingleRow,
        SingleResult = CommandBehavior.SingleResult
    };

    [Flags]
    public enum ColumnType
    {
        String = 1,
        Int,
        Double,
        DateTime
    };

    [Flags]
    public enum LogLevelType
    {
        NONE = 0,
        DEBUG = 1,
        INFO,
        SQLINTEGRITYERROR,
        SQLERROR,
        ERROR
    };
}