using OfficeOpenXml;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {
        public MemoryStream ExportProjectionsCurrentJobs(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportProjectionsCurrentJobs", version);
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

                    //Hours
                    //var columnHours = worksheetImport.Names["Hours"];
                    //var validationHours = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnHours.Start.Column, rowLimit, columnHours.End.Column].Address);
                    //validationHours.Error = "Should be between 0 and 9999999999.99";
                    //validationHours.ShowErrorMessage = true;
                    //validationHours.Formula.Value = 13;
                    //validationHours.AllowBlank = false;
                    //validationHours.Operator = ExcelDataValidationOperator.lessThanOrEqual;
                    
                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<ManhoursProjections> ImportProjectionsCurrentJobs(Stream stream)
        {
            List<ManhoursProjections> ManhoursProjections = new List<ManhoursProjections>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(ManhoursProjections).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var manhoursProjections = new ManhoursProjections();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = manhoursProjections.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(manhoursProjections, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(manhoursProjections, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    ManhoursProjections.Add(manhoursProjections);
                    rowIndex += 1;
                }

            }

            return ManhoursProjections;
        }


    }
}
