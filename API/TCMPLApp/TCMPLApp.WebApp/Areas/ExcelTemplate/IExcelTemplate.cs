using TCMPLApp.WebApp.Areas.ExcelTemplate.Models;
using System.Collections.Generic;
using System.IO;

namespace TCMPLApp.WebApp.Areas.ExcelTemplate
{
    public interface IExcelTemplate
    {
        #region Import

        MemoryStream ValidateImport(Stream stream, IEnumerable<ValidationItem> validationItems);
        
        #endregion

        #region ImportDynamicFormBrick

        MemoryStream ExportEmployeeMaster(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        List<EmployeeMaster> ImportEmployeeMaster(Stream stream);
        Stream ExportEmployeeMaster(string v1, Library.Excel.Template.Models.DictionaryCollection dictionaryCollection, int v2);

        #endregion
    }
}
