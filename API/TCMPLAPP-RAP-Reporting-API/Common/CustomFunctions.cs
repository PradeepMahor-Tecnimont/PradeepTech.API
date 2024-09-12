using RapReportingApi.Models;
using System;
using System.Data;
using System.IO;

namespace RapReportingApi.Common
{
    public static class CustomFunctions
    {
        public static string ConvertDatatableToXML(DataTable dt)
        {
            try
            {
                MemoryStream str = new();
                dt.WriteXml(str, true);
                str.Seek(0, SeekOrigin.Begin);
                StreamReader sr = new(str);
                return sr.ReadToEnd();
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        public static DataTable GetTransposedTable(DataTable inTable)
        {
            DataTable outTable = new();
            outTable.Columns.Add(inTable.Columns[0].ColumnName);

            foreach (DataRow inRow in inTable.Rows)
            {
                string newColName = inRow[0].ToString();
                outTable.Columns.Add(newColName);
            }

            for (int rCount = 1; rCount <= inTable.Columns.Count - 1; rCount++)
            {
                DataRow newRow = outTable.NewRow();

                newRow[0] = inTable.Columns[rCount].ColumnName;
                for (int cCount = 0; cCount <= inTable.Rows.Count - 1; cCount++)
                {
                    string colValue = inTable.Rows[cCount][rCount].ToString();
                    newRow[cCount + 1] = colValue;
                }
                outTable.Rows.Add(newRow);
            }
            return outTable;
        }

        public static string GetRAPRepository(AppSettings appSettings)
        {
            return Path.Combine(appSettings.TCMPLAppTemplatesRepository, appSettings.RAPAppSettings.RAPRepository);
        }

        public static string GetRAPDownloadRepository(AppSettings appSettings)
        {
            return Path.Combine(appSettings.TCMPLAppDownloadRepository, appSettings.RAPAppSettings.RAPRepository);
        }

        public static string GetTempRepository(AppSettings appSettings)
        {
            return appSettings.TCMPLAppTempRepository;
        }
    }
}