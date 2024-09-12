using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using System.Data;
using System.Collections.Generic;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IUtilityRepository
    {
        //public byte[] ExcelDownload(DataTable dt, string ReportTitle, string Sheetname);

        public Task<ProcedureResult> SendEmail(string empNo, string win_Uid, string apprStatus);

        public byte[] ExcelDownloadFromIEnumerable<T>(IEnumerable<T> dt, string ReportTitle, string Sheetname);
        public byte[] ExcelDownloadFromDataTable(DataTable dt, string ReportTitle, string Sheetname);

        public byte[] ExcelPivotDownloadFromIEnumerable<T>(IEnumerable<T> dt, string ReportTitle, string DataSheetname, string PivotSheetName, string[] ColumnLabels, string[] RowLabels, string[] ValuesLableCount, string[] ValuesLabelSum = null);


        public byte[] ExcelDownloadWithMultipleSheets(List<ExcelSheetAttributes> sheetAttributes);

    }
}