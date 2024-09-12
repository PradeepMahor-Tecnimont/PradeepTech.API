using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using OfficeOpenXml.Style;
using System.Drawing;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {

        #region Import
        public MemoryStream ValidateMfgId(Stream stream, IEnumerable<ValidationItem> validationItems)
        {

            var excelPackage = new ExcelPackage(stream);
            var workbook = excelPackage.Workbook;
            var worksheetImport = workbook.Worksheets[0];

            foreach (var validationItem in validationItems)
            {

                var column = worksheetImport.Names[validationItem.FieldName];
                var cell = worksheetImport.Cells[validationItem.ExcelRowNumber + 1, column.Start.Column];

                cell.Style.Fill.PatternType = ExcelFillStyle.Solid;
                if (validationItem.ErrorType == ValidationItemErrorTypeEnum.Critical)
                {
                    cell.Style.Fill.BackgroundColor.SetColor(Color.Red);
                }
                if (validationItem.ErrorType == ValidationItemErrorTypeEnum.Warning)
                {
                    cell.Style.Fill.BackgroundColor.SetColor(Color.Yellow);
                }
                cell.AddComment(validationItem.Message, "System");

            }

            var ms = new MemoryStream();
            excelPackage.SaveAs(ms);
            return ms;
        }
        #endregion


        #region ImportConsumable

        public MemoryStream ExportConsumables(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportDMSConsumables", version);
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

                    var rowNumber = 1;

                    foreach (var g in dictionaryCollection.DictionaryItems.GroupBy(c => c.FieldName))
                    {

                        var rangeName = g.Key;
                        var startRow = rowNumber;
                        foreach (var dictionaryItem in dictionaryCollection.DictionaryItems.Where(c => c.FieldName == rangeName).OrderBy(c => c.FieldName))
                        {
                            worksheetDictionary.Cells[rowNumber, 1].Value = dictionaryItem.FieldName;
                            worksheetDictionary.Cells[rowNumber, 2].Value = dictionaryItem.Value;
                            rowNumber += 1;
                        }
                        var endRow = rowNumber;

                        var columnRange = worksheetImport.Names[rangeName.Replace("Enum", "")];
                        var val = worksheetImport.DataValidations.AddListValidation(worksheetImport.Cells[2, columnRange.Start.Column, rowLimit, columnRange.End.Column].Address);
                        val.ShowErrorMessage = true;
                        val.ShowInputMessage = true;
                        val.Formula.ExcelFormula = worksheetDictionary.Cells[startRow, 2, endRow - 1, 2].FullAddressAbsolute;

                    }

                    //var columnStartDate = worksheetImport.Names["StartDate"];
                    //var validationStartDate = worksheetImport.DataValidations.AddDateTimeValidation(worksheetImport.Cells[2, columnStartDate.Start.Column, rowLimit, columnStartDate.End.Column].Address);
                    //validationStartDate.Error = "StartDate should not be prior to one year.";
                    //validationStartDate.ShowErrorMessage = true;
                    //validationStartDate.Formula.ExcelFormula = "TODAY()-365";
                    //validationStartDate.AllowBlank = false;
                    //validationStartDate.Operator = ExcelDataValidationOperator.greaterThanOrEqual;

                    //var columnEndDate = worksheetImport.Names["EndDate"];
                    //var validationEndDate = worksheetImport.DataValidations.AddDateTimeValidation(worksheetImport.Cells[2, columnEndDate.Start.Column, rowLimit, columnEndDate.End.Column].Address);
                    //validationEndDate.Error = "End date should be greater than StartDate.";
                    //validationEndDate.ShowErrorMessage = true;
                    //validationEndDate.Formula.ExcelFormula = worksheetImport.Cells[2, columnStartDate.Start.Column].Address;
                    //validationEndDate.AllowBlank = false;
                    //validationEndDate.Operator = ExcelDataValidationOperator.greaterThanOrEqual;

                    //var columnEmpno = worksheetImport.Names["Empno"];
                    //var validationEmpno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2,columnEmpno.Start.Column, rowLimit,columnEmpno.End.Column].Address);
                    //validationEmpno.Error = "Empno length should 5 characters.";
                    //validationEmpno.ShowErrorMessage = true;
                    //validationEmpno.Formula.Value = 5;
                    //validationEmpno.AllowBlank = false;
                    //validationEmpno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //var columnNoOfDays = worksheetImport.Names["NoOfDays"];
                    //var validationNoOfDays = worksheetImport.DataValidations.AddDecimalValidation(worksheetImport.Cells[2, columnNoOfDays.Start.Column, rowLimit, columnNoOfDays.End.Column].Address);
                    //validationNoOfDays.Error = "NoOfDays should be greater than 0.";
                    //validationNoOfDays.ShowErrorMessage = true;
                    //validationNoOfDays.Formula.Value = 0;

                    //validationNoOfDays.AllowBlank = false;
                    //validationNoOfDays.Operator = ExcelDataValidationOperator.greaterThan;


                    var columnReason = worksheetImport.Names["ItemMfgId"];
                    var validationReason = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnReason.Start.Column, rowLimit, columnReason.End.Column].Address);
                    validationReason.Error = "Reason length should be less than 20 characters";
                    validationReason.ShowErrorMessage = true;
                    validationReason.Formula.Value = 20;
                    validationReason.AllowBlank = false;
                    validationReason.Operator = ExcelDataValidationOperator.lessThanOrEqual;


                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<Consumable> ImportConsumables(Stream stream)
        {
            List<Consumable> Consumables = new List<Consumable>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(Consumable).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var Consumable = new Consumable();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = Consumable.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(Consumable, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(Consumable, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    Consumables.Add(Consumable);
                    rowIndex += 1;
                }

            }

            return Consumables;
        }


        #endregion

    }

}
