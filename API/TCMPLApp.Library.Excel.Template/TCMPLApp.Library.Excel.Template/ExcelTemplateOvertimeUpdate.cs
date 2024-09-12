using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {
        public MemoryStream ExportOvertimeUpdate(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportOvertimeUpdate", version);
            var resourceName = string.Format("TCMPLApp.Library.Excel.Template.Template.{0}", filename);

            using (var resourceStream = assembly.GetManifestResourceStream(resourceName))
            {

                if (resourceStream == null)
                {
                    throw new Exception("Template not found");
                }

                using (var ms = new MemoryStream())
                {
                    var excelPackage = new ExcelPackage(ms, resourceStream);
                    var workbook = excelPackage.Workbook;
                    var worksheetDictionary = workbook.Worksheets[1];
                    var worksheetImport = workbook.Worksheets[0];                    

                    //OT
                    var columnHours = worksheetImport.Names["OT"];
                    var validationHours = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnHours.Start.Column, rowLimit, columnHours.End.Column].Address);
                    validationHours.Error = "Should be between 1 and 100";
                    validationHours.ShowErrorMessage = true;
                    validationHours.Formula.Value = 3;
                    validationHours.AllowBlank = false;
                    validationHours.Operator = ExcelDataValidationOperator.lessThanOrEqual;
                    
                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<OvertimeUpdate> ImportOvertimeUpdate(Stream stream)
        {
            List<OvertimeUpdate> OvertimeUpdate = new List<OvertimeUpdate>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(OvertimeUpdate).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var overtimeUpdate = new OvertimeUpdate();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = overtimeUpdate.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(overtimeUpdate, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(overtimeUpdate, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    OvertimeUpdate.Add(overtimeUpdate);
                    rowIndex += 1;
                }
            }

            return OvertimeUpdate;
        }


    }
}
