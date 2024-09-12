
CREATE TABLE DG_MID_TRANSFER_STATUS (
    VALUE       NUMBER NOT NULL,
    DESCRIPTION VARCHAR2(50) NOT NULL,
    STATUS      NUMBER NOT NULL,
    CONSTRAINT DG_MID_TRANSFER_STATUS_PK PRIMARY KEY ( VALUE ) ENABLE
);

INSERT INTO "TCMPL_HR"."DG_MID_TRANSFER_STATUS" (VALUE, DESCRIPTION, STATUS) VALUES ('0', 'Pending', '1');
INSERT INTO "TCMPL_HR"."DG_MID_TRANSFER_STATUS" (VALUE, DESCRIPTION, STATUS) VALUES ('1', 'Approved by HOD', '1');
INSERT INTO "TCMPL_HR"."DG_MID_TRANSFER_STATUS" (VALUE, DESCRIPTION, STATUS) VALUES ('2', 'Approved By HR', '1');
INSERT INTO "TCMPL_HR"."DG_MID_TRANSFER_STATUS" (VALUE, DESCRIPTION, STATUS) VALUES ('-1', 'Rejected by HOD', '1');
INSERT INTO "TCMPL_HR"."DG_MID_TRANSFER_STATUS" (VALUE, DESCRIPTION, STATUS) VALUES ('-2', 'Rejected By HR', '1');

ALTER TABLE DG_MID_TRANSFER_COSTCODE
    ADD CONSTRAINT DG_MID_TRANSFER_COSTCODE_FK2 FOREIGN KEY ( STATUS )
        REFERENCES DG_MID_TRANSFER_STATUS ( VALUE )
    ENABLE;

GRANT UPDATE ON "TCMPL_HR"."DG_MID_TRANSFER_STATUS" TO "TCMPL_APP_CONFIG";
GRANT SELECT ON "TCMPL_HR"."DG_MID_TRANSFER_STATUS" TO "TCMPL_APP_CONFIG";
GRANT INSERT ON "TCMPL_HR"."DG_MID_TRANSFER_STATUS" TO "TCMPL_APP_CONFIG";
GRANT DELETE ON "TCMPL_HR"."DG_MID_TRANSFER_STATUS" TO "TCMPL_APP_CONFIG";      