Create Table emp_exclude_from_moc5 (
    empno       Varchar2(5) Not Null,
    modified_on Date Default sysdate Not Null,
    modified_by Varchar2(5) Not Null,
    Constraint emp_exclude_from_moc5_pk Primary Key ( empno ) Enable
);