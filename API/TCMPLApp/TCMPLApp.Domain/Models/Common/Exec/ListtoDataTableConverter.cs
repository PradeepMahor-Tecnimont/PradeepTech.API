using System;
using System.Collections.Generic;
using System.Data;
using System.Reflection;

namespace TCMPLApp.Domain.Models.Common
{
    public class ListtoDataTableConverter
    {
        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name);
            }

            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    if (Props[i].GetValue(item, null) is System.DateTime)
                    {
                        //values[i] = (System.DateTime)(Props[i].GetValue(item, null));
                        values[i] = Convert.ToDateTime(Props[i].GetValue(item, null)).ToString("dd-MM-yyyy");
                    } 
                    else
                    {
                        values[i] = Props[i].GetValue(item, null);
                    }


                    
                }
                dataTable.Rows.Add(values);
            }

            //put a breakpoint here and check datatable
            return dataTable;
        }
    }
}
