using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using System.Data;
using System.Collections.Generic;
using DocumentFormat.OpenXml.Spreadsheet;

namespace TCMPLApp.DataAccess.Repositories.Timesheet
{
    public interface IOpenXMLUtilityRepository
    {
        public byte[] ExcelDownloadFromDataTable<T>(IEnumerable<T> lt, 
                                                    string reportTitle, 
                                                    string templateName, 
                                                    string fileName, 
                                                    string sheetName, 
                                                    int[] columnGetTotals, 
                                                    int[] columnSetTotals, 
                                                    int[] rowColumnSetTotals,
                                                    string[] multipleColumnGetTotals, 
                                                    int[] multipleColumnSetTotals, 
                                                    int[] rowMultipleColumnSetTotals);

    }
}