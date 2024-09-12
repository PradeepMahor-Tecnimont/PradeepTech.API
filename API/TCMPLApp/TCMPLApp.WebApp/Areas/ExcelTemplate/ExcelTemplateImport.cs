using TCMPLApp.WebApp.Areas.ExcelTemplate.Models;
using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;

namespace TCMPLApp.WebApp.Areas.ExcelTemplate
{
    public partial class ExcelTemplateImport : IExcelTemplate
    {
        #region Import
        
        public MemoryStream ValidateImport(Stream stream, IEnumerable<ValidationItem> validationItems)
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

        #region Employee Master

        public MemoryStream ExportEmployeeMaster(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {

            var assembly = Assembly.GetExecutingAssembly();
            //System.IO.Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
            //var DDIR = System.IO.Directory.GetCurrentDirectory().ToString();
            //string path = Path.Combine(DDIR);
            var filename = string.Format("{0} {1}.xlsx", "ImportEmployeeMaster", version);
            //var resourceName = string.Format("TCMPLApp.WebApp.Areas.ExcelTemplate.{0}", filename);
            var resourceName = string.Format("TCMPLApp.WebApp.Areas.ExcelTemplate.Template.{0}", filename);
            //D:\tpltfs\TCMPLApp\TCMPLApp\TCMPLApp.WebApp\Areas\ExcelTemplate\Template\ImportEmployeeMaster v01.xlsx
            //D:\tpltfs\TCMPLApp\TCMPLApp\TCMPLApp.WebApp\Areas\ExcelTemplate\Template\ImportEmployeeMaster v01.xlsx
            //if (!File.Exists("TCMPLApp.WebApp.Areas.ExcelTemplate.Template.ImportEmployeeMaster v01.xlsx"))
            //if (!File.Exists(resourceName))
            //{
            //    var v_success = "";
            //} else
            //{
            //    var v_falied = "" ;
            //}

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

                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }

        }

        public List<EmployeeMaster> ImportEmployeeMaster(Stream stream)
        {

            List<EmployeeMaster> employees = new List<EmployeeMaster>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(EmployeeMaster).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var employee = new EmployeeMaster();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = employee.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo.SetValue(employee, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo.SetValue(employee, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    employees.Add(employee);
                    rowIndex += 1;
                }

            }

            return employees;
        }

        #endregion
    }
}
