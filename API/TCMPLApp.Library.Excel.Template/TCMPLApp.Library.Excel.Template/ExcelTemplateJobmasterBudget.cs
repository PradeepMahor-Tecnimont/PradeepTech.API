using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Library.Excel.Template.Models;
using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using OfficeOpenXml.Style;
using System.Reflection;
using System.Data;
using System.Dynamic;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {
        public MemoryStream ExportJobmasterBudget(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportJobmasterBudget", version);
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

                    //Projno
                    var columnProjno = worksheetImport.Names["Projno"];
                    var validationProjno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnProjno.Start.Column, rowLimit, columnProjno.End.Column].Address);
                    validationProjno.Error = "Job number length should 5 characters.";
                    validationProjno.ShowErrorMessage = true;
                    validationProjno.Formula.Value = 5;
                    validationProjno.AllowBlank = false;
                    validationProjno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    // Phase 
                    var columnPhase = worksheetImport.Names["Phase"];
                    var validationPhase = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPhase.Start.Column, rowLimit, columnPhase.End.Column].Address);
                    validationPhase.Error = "Phase length should 2 characters.";
                    validationPhase.ShowErrorMessage = true;
                    validationPhase.Formula.Value = 2;
                    validationPhase.AllowBlank = false;
                    validationPhase.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    // Yymm 
                    var columnYymm = worksheetImport.Names["Yymm"];
                    var validationYymm = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnYymm.Start.Column, rowLimit, columnYymm.End.Column].Address);
                    validationYymm.Error = "YYMM length should 6 characters.";
                    validationYymm.ShowErrorMessage = true;
                    validationYymm.Formula.Value = 6;
                    validationYymm.AllowBlank = false;
                    validationYymm.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    // Costcode    
                    var columnCostcode = worksheetImport.Names["Costcode"];
                    var validationCostcode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnCostcode.Start.Column, rowLimit, columnCostcode.End.Column].Address);
                    validationCostcode.Error = "Job number length should 4 characters.";
                    validationCostcode.ShowErrorMessage = true;
                    validationCostcode.Formula.Value = 4;
                    validationCostcode.AllowBlank = false;
                    validationCostcode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    // InitialBudget 
                    var columnInitialBudget = worksheetImport.Names["InitialBudget"];
                    var validationInitialBudget = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnInitialBudget.Start.Column, rowLimit, columnInitialBudget.End.Column].Address);
                    validationInitialBudget.Error = "Should be between -9999999 and 9999999";                                       
                    validationInitialBudget.AllowBlank = true;
                    validationInitialBudget.ShowErrorMessage = true;
                    validationInitialBudget.Operator = ExcelDataValidationOperator.between;
                    validationInitialBudget.Formula.Value = -9999999;
                    validationInitialBudget.Formula2.Value = 9999999;

                    // NewBudget
                    var columnNewBudget = worksheetImport.Names["NewBudget"];
                    var validationNewBudget = worksheetImport.DataValidations.AddIntegerValidation(worksheetImport.Cells[2, columnNewBudget.Start.Column, rowLimit, columnNewBudget.End.Column].Address);
                    validationNewBudget.Error = "Should be between -9999999 and 9999999";
                    validationNewBudget.AllowBlank = true;
                    validationNewBudget.ShowErrorMessage = true;
                    validationNewBudget.Operator = ExcelDataValidationOperator.between;
                    validationNewBudget.Formula.Value = -9999999;
                    validationNewBudget.Formula2.Value = 9999999;

                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<JobmasterBudget> ImportJobmasterBudget(Stream stream)
        {
            List<JobmasterBudget> JobBudgetItems = new List<JobmasterBudget>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(JobmasterBudget).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var jobmasterBudget = new JobmasterBudget();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = jobmasterBudget.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(jobmasterBudget, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(jobmasterBudget, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    JobBudgetItems.Add(jobmasterBudget);
                    rowIndex += 1;
                }
            }

            return JobBudgetItems;
        }
    }
}
