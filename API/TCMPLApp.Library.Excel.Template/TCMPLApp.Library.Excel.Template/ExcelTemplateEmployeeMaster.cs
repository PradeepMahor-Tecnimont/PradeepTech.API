using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {
        public MemoryStream ExportEmployeeMaster(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportEmployeeMaster", version);
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

                    //var rowNumber = 1;

                    //foreach (var g in dictionaryCollection.DictionaryItems.GroupBy(c => c.FieldName))
                    //{

                    //    var rangeName = g.Key;
                    //    var startRow = rowNumber;
                    //    foreach (var dictionaryItem in dictionaryCollection.DictionaryItems.Where(c => c.FieldName == rangeName).OrderBy(c => c.FieldName))
                    //    {
                    //        worksheetDictionary.Cells[rowNumber, 1].Value = dictionaryItem.FieldName;
                    //        worksheetDictionary.Cells[rowNumber, 2].Value = dictionaryItem.Value;
                    //        rowNumber += 1;
                    //    }
                    //    var endRow = rowNumber;

                    //    var columnRange = worksheetImport.Names[rangeName.Replace("Enum", "")];
                    //    var val = worksheetImport.DataValidations.AddListValidation(worksheetImport.Cells[2, columnRange.Start.Column, rowLimit, columnRange.End.Column].Address);
                    //    val.ShowErrorMessage = true;
                    //    val.ShowInputMessage = true;
                    //    val.Formula.ExcelFormula = worksheetDictionary.Cells[startRow, 2, endRow - 1, 2].FullAddressAbsolute;

                    //}

                    //Empno
                    var columnEmpno = worksheetImport.Names["Empno"];
                    var validationEmpno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnEmpno.Start.Column, rowLimit, columnEmpno.End.Column].Address);
                    validationEmpno.Error = "Empno length should 5 characters.";
                    validationEmpno.ShowErrorMessage = true;
                    validationEmpno.Formula.Value = 5;
                    validationEmpno.AllowBlank = false;
                    validationEmpno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //First Name
                    var columnFirstName = worksheetImport.Names["FirstName"];
                    var validationFirstName = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnFirstName.Start.Column, rowLimit, columnFirstName.End.Column].Address);
                    validationFirstName.Error = "First Name length should 50 characters.";
                    validationFirstName.ShowErrorMessage = true;
                    validationFirstName.Formula.Value = 50;
                    validationFirstName.AllowBlank = false;
                    validationFirstName.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Middle Name
                    var columnName = worksheetImport.Names["MiddleName"];
                    var validationName = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnName.Start.Column, rowLimit, columnName.End.Column].Address);
                    validationName.Error = "Name length should 50 characters.";
                    validationName.ShowErrorMessage = true;
                    validationName.Formula.Value = 50;
                    validationName.AllowBlank = false;
                    validationName.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Last Name
                    var columnLastName = worksheetImport.Names["LastName"];
                    var validationLastName = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnLastName.Start.Column, rowLimit, columnLastName.End.Column].Address);
                    validationLastName.Error = "Name length should 50 characters.";
                    validationLastName.ShowErrorMessage = true;
                    validationLastName.Formula.Value = 50;
                    validationLastName.AllowBlank = false;
                    validationLastName.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Emptype
                    var columnEmpType = worksheetImport.Names["EmpType"];
                    var validationEmpType = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnEmpType.Start.Column, rowLimit, columnEmpType.End.Column].Address);
                    validationEmpType.Error = "EmpType length should 1 character.";
                    validationEmpType.ShowErrorMessage = true;
                    validationEmpType.Formula.Value = 1;
                    validationEmpType.AllowBlank = false;
                    validationEmpType.Operator = ExcelDataValidationOperator.equal;

                    //Gender
                    var columnGender = worksheetImport.Names["Gender"];
                    var validationGender = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnGender.Start.Column, rowLimit, columnGender.End.Column].Address);
                    validationGender.Error = "Gender length should 1 character.";
                    validationGender.ShowErrorMessage = true;
                    validationGender.Formula.Value = 1;
                    validationGender.AllowBlank = false;
                    validationGender.Operator = ExcelDataValidationOperator.equal;

                    //Category
                    var columnCategory = worksheetImport.Names["Category"];
                    var validationCategory = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnCategory.Start.Column, rowLimit, columnCategory.End.Column].Address);
                    validationCategory.Error = "Category length should 1 character.";
                    validationCategory.ShowErrorMessage = true;
                    validationCategory.Formula.Value = 1;
                    validationCategory.AllowBlank = false;
                    validationCategory.Operator = ExcelDataValidationOperator.equal;

                    //Grade
                    var columnGrade = worksheetImport.Names["Grade"];
                    var validationGrade = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnGrade.Start.Column, rowLimit, columnGrade.End.Column].Address);
                    validationGrade.Error = "Grade length should 2 characters.";
                    validationGrade.ShowErrorMessage = true;
                    validationGrade.Formula.Value = 2;
                    validationGrade.AllowBlank = false;
                    validationGrade.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    ////Designation
                    var columnDesignation = worksheetImport.Names["Designation"];
                    var validationDesignation = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnDesignation.Start.Column, rowLimit, columnDesignation.End.Column].Address);
                    validationDesignation.Error = "Designation length should 6 characters.";
                    validationDesignation.ShowErrorMessage = true;
                    validationDesignation.Formula.Value = 6;
                    validationDesignation.AllowBlank = false;
                    validationDesignation.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //DOB
                    var columnDOB = worksheetImport.Names["DOB"];
                    var validationDOB = worksheetImport.DataValidations.AddDateTimeValidation(worksheetImport.Cells[2, columnDOB.Start.Column, rowLimit, columnDOB.End.Column].Address);
                    validationDOB.Error = "DOB should not be later today";
                    validationDOB.ShowErrorMessage = true;
                    validationDOB.Formula.ExcelFormula = "TODAY()";
                    validationDOB.AllowBlank = false;
                    validationDOB.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //DOJ
                    var columnDOJ = worksheetImport.Names["DOJ"];
                    var validationDOJ = worksheetImport.DataValidations.AddDateTimeValidation(worksheetImport.Cells[2, columnDOJ.Start.Column, rowLimit, columnDOJ.End.Column].Address);
                    validationDOJ.Error = "DOJ should not be later today";
                    validationDOJ.ShowErrorMessage = true;
                    validationDOJ.Formula.ExcelFormula = "TODAY()";
                    validationDOJ.AllowBlank = false;
                    validationDOJ.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    ////ContractEndDate


                    //Parent
                    var columnParent = worksheetImport.Names["Parent"];
                    var validationParent = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnParent.Start.Column, rowLimit, columnParent.End.Column].Address);
                    validationParent.Error = "Parent length should 4 characters.";
                    validationParent.ShowErrorMessage = true;
                    validationParent.Formula.Value = 4;
                    validationParent.AllowBlank = false;
                    validationParent.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Assigned
                    var columnAssingn = worksheetImport.Names["Assigned"];
                    var validationAssingn = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAssingn.Start.Column, rowLimit, columnAssingn.End.Column].Address);
                    validationAssingn.Error = "Assign length should 4 characters.";
                    validationAssingn.ShowErrorMessage = true;
                    validationAssingn.Formula.Value = 4;
                    validationAssingn.AllowBlank = false;
                    validationAssingn.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Office
                    var columnOffice = worksheetImport.Names["Office"];
                    var validationOffice = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnOffice.Start.Column, rowLimit, columnOffice.End.Column].Address);
                    validationOffice.Error = "Office length should 2 characters.";
                    validationOffice.ShowErrorMessage = true;
                    validationOffice.Formula.Value = 2;
                    validationOffice.AllowBlank = false;
                    validationOffice.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //SubcontractAgency
                    //var columnSubcontract = worksheetImport.Names["SubcontractAgency"];
                    //var validationSubcontract = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnSubcontract.Start.Column, rowLimit, columnSubcontract.End.Column].Address);
                    //validationSubcontract.Error = "SubcontractAgency length should 3 characters.";
                    //validationSubcontract.ShowErrorMessage = true;
                    //validationSubcontract.Formula.Value = 3;
                    //validationSubcontract.AllowBlank = false;
                    //validationSubcontract.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Location
                    var columnLocation = worksheetImport.Names["Location"];
                    var validationLocation = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnLocation.Start.Column, rowLimit, columnLocation.End.Column].Address);
                    validationLocation.Error = "Location length should 1 character.";
                    validationLocation.ShowErrorMessage = true;
                    validationLocation.Formula.Value = 1;
                    validationLocation.AllowBlank = false;
                    validationLocation.Operator = ExcelDataValidationOperator.equal;

                    //Place
                    var columnPlace = worksheetImport.Names["Place"];
                    var validationPlace = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPlace.Start.Column, rowLimit, columnPlace.End.Column].Address);
                    validationPlace.Error = "Place length should 3 characters.";
                    validationPlace.ShowErrorMessage = true;
                    validationPlace.Formula.Value = 3;
                    validationPlace.AllowBlank = false;
                    validationPlace.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    workbook.Worksheets[1].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<Employee> ImportEmployeeMaster(Stream stream)
        {
            List<Employee> Employees = new List<Employee>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets[0];

                var props = typeof(Employee).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var employee = new Employee();
                    foreach (var prop in props)
                    {
                        var column = worksheet.Names[prop.Name];
                        var type = employee.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(employee, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(employee, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, pinfo.PropertyType));
                            }
                        }

                    }
                    Employees.Add(employee);
                    rowIndex += 1;
                }

            }

            return Employees;
        }


    }
}
