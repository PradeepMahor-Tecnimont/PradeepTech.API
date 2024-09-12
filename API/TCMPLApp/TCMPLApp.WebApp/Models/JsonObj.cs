using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class JsonObj
    {
        public DataTable data = new DataTable();

        public JsonObj()
        {
            DataColumn[] dc = new DataColumn[] {
                 new DataColumn("EMPNO", typeof(string)),
                 new DataColumn("IS_ACCEPTED", typeof(string)),
            };

            data.Columns.AddRange(dc);
        }
    }

    public class JsonObjHr
    {
        public DataTable data = new DataTable();

        public JsonObjHr()
        {
            DataColumn[] dc = new DataColumn[] {
                new DataColumn("EMPNO", typeof(string)),
                new DataColumn("IS_ACCEPTED", typeof(string)),
                new DataColumn("HOD_APPRL", typeof(string)),
            };

            data.Columns.AddRange(dc);
        }
    }
}