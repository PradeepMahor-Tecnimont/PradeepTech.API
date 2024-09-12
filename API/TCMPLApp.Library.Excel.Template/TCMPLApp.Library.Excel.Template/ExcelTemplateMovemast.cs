using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using System.Data;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {
        public MemoryStream ExportMovemast(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportMovemast", version);
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
                    var worksheetDictionary = workbook.Worksheets["Dictionary"];
                    var worksheetImport = workbook.Worksheets["Import"];

                    var rowNumber = 1;

                    foreach (var g in dictionaryCollection.DictionaryItems.GroupBy(c => c.FieldName))
                    {

                        var rangeName = g.Key;
                        var startRow = rowNumber;
                        foreach (var dictionaryItem in dictionaryCollection.DictionaryItems.Where(c => c.FieldName == rangeName).OrderBy(c => c.FieldName))
                        {
                            string[] costcodeSplitList = dictionaryItem.Value.ToString().Split("-");

                            if (costcodeSplitList.Length > 0)
                            { 
                                worksheetDictionary.Cells[rowNumber, 1].Value = costcodeSplitList[0];

                                if (costcodeSplitList.Length > 1 && costcodeSplitList[1] != null)
                                {
                                    worksheetDictionary.Cells[rowNumber, 2].Value = costcodeSplitList[1];
                                }
                            }

                            rowNumber += 1;
                        } 
                    }

                    // Costcode    
                    var columnCostcode = worksheetImport.Names["Costcode"];
                    var validationCostcode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnCostcode.Start.Column, rowLimit, columnCostcode.End.Column].Address);
                    validationCostcode.Error = "Job number length should 4 characters.";
                    validationCostcode.ShowErrorMessage = true;
                    validationCostcode.Formula.Value = 4;
                    validationCostcode.AllowBlank = false;
                    validationCostcode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    // Yymm 
                    var columnYymm = worksheetImport.Names["Yymm"];
                    var validationYymm = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnYymm.Start.Column, rowLimit, columnYymm.End.Column].Address);
                    validationYymm.Error = "YYMM length should 6 characters.";
                    validationYymm.ShowErrorMessage = true;
                    validationYymm.Formula.Value = 6;
                    validationYymm.AllowBlank = false;
                    validationYymm.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    // Movetotcm
                    var columnMovetotcm = worksheetImport.Names["Movetotcm"];
                    var validationMovetotcm = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnMovetotcm.Start.Column, rowLimit, columnMovetotcm.End.Column].Address);
                    validationMovetotcm.Error = "Should be between -99999999 and 99999999";
                    validationMovetotcm.AllowBlank = true;
                    validationMovetotcm.ShowErrorMessage = true;
                    validationMovetotcm.Operator = ExcelDataValidationOperator.between;
                    validationMovetotcm.Formula.Value = -99999999;
                    validationMovetotcm.Formula2.Value = 99999999;

                    // Movetosite
                    var columnMovetosite = worksheetImport.Names["Movetosite"];
                    var validationMovetosite = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnMovetosite.Start.Column, rowLimit, columnMovetosite.End.Column].Address);
                    validationMovetosite.Error = "Should be between -99999999 and 99999999";
                    validationMovetosite.AllowBlank = true;
                    validationMovetosite.ShowErrorMessage = true;
                    validationMovetosite.Operator = ExcelDataValidationOperator.between;
                    validationMovetosite.Formula.Value = -99999999;
                    validationMovetosite.Formula2.Value = 99999999;

                    // Movetoothers
                    var columnMovetoothers = worksheetImport.Names["Movetoothers"];
                    var validationMovetoothers = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnMovetoothers.Start.Column, rowLimit, columnMovetoothers.End.Column].Address);
                    validationMovetoothers.Error = "Should be between -99999999 and 99999999";
                    validationMovetoothers.AllowBlank = true;
                    validationMovetoothers.ShowErrorMessage = true;
                    validationMovetoothers.Operator = ExcelDataValidationOperator.between;
                    validationMovetoothers.Formula.Value = -99999999;
                    validationMovetoothers.Formula2.Value = 99999999;

                    // ExtSubcontract
                    var columnExtSubcontract = worksheetImport.Names["ExtSubcontract"];
                    var validationExtSubcontract = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnExtSubcontract.Start.Column, rowLimit, columnExtSubcontract.End.Column].Address);
                    validationExtSubcontract.Error = "Should be between -99999999 and 99999999";
                    validationExtSubcontract.AllowBlank = true;
                    validationExtSubcontract.ShowErrorMessage = true;
                    validationExtSubcontract.Operator = ExcelDataValidationOperator.between;
                    validationExtSubcontract.Formula.Value = -99999999;
                    validationExtSubcontract.Formula2.Value = 99999999;

                    // FutRecruit
                    var columnFutRecruit = worksheetImport.Names["FutRecruit"];
                    var validationFutRecruit = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnFutRecruit.Start.Column, rowLimit, columnFutRecruit.End.Column].Address);
                    validationFutRecruit.Error = "Should be between -99999999 and 99999999";
                    validationFutRecruit.AllowBlank = true;
                    validationFutRecruit.ShowErrorMessage = true;
                    validationFutRecruit.Operator = ExcelDataValidationOperator.between;
                    validationFutRecruit.Formula.Value = -99999999;
                    validationFutRecruit.Formula2.Value = 99999999;

                    // IntDept
                    var columnIntDept = worksheetImport.Names["IntDept"];
                    var validationIntDept = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnIntDept.Start.Column, rowLimit, columnIntDept.End.Column].Address);
                    validationIntDept.Error = "Should be between -99999999 and 99999999";
                    validationIntDept.AllowBlank = true;
                    validationIntDept.ShowErrorMessage = true;
                    validationIntDept.Operator = ExcelDataValidationOperator.between;
                    validationIntDept.Formula.Value = -99999999;
                    validationIntDept.Formula2.Value = 99999999;

                    // HrsSubcont
                    var columnHrsSubcont = worksheetImport.Names["HrsSubcont"];
                    var validationHrsSubcont = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnHrsSubcont.Start.Column, rowLimit, columnHrsSubcont.End.Column].Address);
                    validationHrsSubcont.Error = "Should be between -99999999 and 99999999";
                    validationHrsSubcont.AllowBlank = true;
                    validationHrsSubcont.ShowErrorMessage = true;
                    validationHrsSubcont.Operator = ExcelDataValidationOperator.between;
                    validationHrsSubcont.Formula.Value = -99999999;
                    validationHrsSubcont.Formula2.Value = 99999999;

                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<Movemast> ImportMovemast(Stream stream)
        {
            List<Movemast> MovemastItems = new List<Movemast>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(Movemast).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var movemast = new Movemast();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = movemast.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(movemast, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(movemast, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    MovemastItems.Add(movemast);
                    rowIndex += 1;
                }
            }

            return MovemastItems;
        }
    }
}
