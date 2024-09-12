using OfficeOpenXml;
using OfficeOpenXml.DataValidation;
using System.Data;
using System.Reflection;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public partial class ExcelTemplate : IExcelTemplate
    {        
        public MemoryStream ExportHRMastersCustom(string version, DictionaryCollection dictionaryCollection, int rowLimit)
        {
            var assembly = Assembly.GetExecutingAssembly();
            var filename = string.Format("{0} {1}.xlsx", "ImportHRMastersCustom", version);
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

                    //Empno
                    var columnEmpno = worksheetImport.Names["Empno"];
                    var validationEmpno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnEmpno.Start.Column, rowLimit, columnEmpno.End.Column].Address);
                    validationEmpno.Error = "Employee number length should 5 characters.";
                    validationEmpno.ShowErrorMessage = true;
                    validationEmpno.Formula.Value = 5;
                    validationEmpno.AllowBlank = false;
                    validationEmpno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Category	
                    var columnCategory = worksheetImport.Names["Category"];
                    var validationCategory = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnCategory.Start.Column, rowLimit, columnCategory.End.Column].Address);
                    validationCategory.Error = "Category length should 1 character.";
                    validationCategory.ShowErrorMessage = true;
                    validationCategory.Formula.Value = 1;
                    validationCategory.AllowBlank = true;
                    validationCategory.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Desgcode	
                    var columnDesgcode = worksheetImport.Names["Desgcode"];
                    var validationDesgcode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnDesgcode.Start.Column, rowLimit, columnDesgcode.End.Column].Address);
                    validationDesgcode.Error = "Desgcode length should 6 characters.";
                    validationDesgcode.ShowErrorMessage = true;
                    validationDesgcode.Formula.Value = 6;
                    validationDesgcode.AllowBlank = true;
                    validationDesgcode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Doc	
                    var columnDoc = worksheetImport.Names["Doc"];
                    var validationDoc = worksheetImport.DataValidations.AddDateTimeValidation(worksheetImport.Cells[2, columnDoc.Start.Column, rowLimit, columnDoc.End.Column].Address);
                    validationDoc.Error = "Doc should not be later today";
                    validationDoc.ShowErrorMessage = true;
                    validationDoc.Formula.ExcelFormula = "TODAY()";
                    validationDoc.AllowBlank = true;
                    validationDoc.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Grade	
                    var columnGrade = worksheetImport.Names["Grade"];
                    var validationGrade = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnGrade.Start.Column, rowLimit, columnGrade.End.Column].Address);
                    validationGrade.Error = "Grade length should 2 characters.";
                    validationGrade.ShowErrorMessage = true;
                    validationGrade.Formula.Value = 2;
                    validationGrade.AllowBlank = true;
                    validationGrade.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Married	
                    var columnMarried = worksheetImport.Names["Married"];
                    var validationMarried = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnMarried.Start.Column, rowLimit, columnMarried.End.Column].Address);
                    validationMarried.Error = "Married length should 1 character.";
                    validationMarried.ShowErrorMessage = true;
                    validationMarried.Formula.Value = 1;
                    validationMarried.AllowBlank = true;
                    validationMarried.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Assign	
                    var columnAssign = worksheetImport.Names["Assign"];
                    var validationAssign = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAssign.Start.Column, rowLimit, columnAssign.End.Column].Address);
                    validationAssign.Error = "Assign length should 4 characters.";
                    validationAssign.ShowErrorMessage = true;
                    validationAssign.Formula.Value = 4;
                    validationAssign.AllowBlank = true;
                    validationAssign.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Abbrivation	
                    var columnAbbrivation = worksheetImport.Names["Abbrivation"];
                    var validationAbbrivation = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAbbrivation.Start.Column, rowLimit, columnAbbrivation.End.Column].Address);
                    validationAbbrivation.Error = "Abbrivation length should 5 characters.";
                    validationAbbrivation.ShowErrorMessage = true;
                    validationAbbrivation.Formula.Value = 5;
                    validationAbbrivation.AllowBlank = true;
                    validationAbbrivation.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Email	
                    var columnEmail = worksheetImport.Names["Email"];
                    var validationEmail = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnEmail.Start.Column, rowLimit, columnEmail.End.Column].Address);
                    validationEmail.Error = "Email length should 100 characters.";
                    validationEmail.ShowErrorMessage = true;
                    validationEmail.Formula.Value = 100;
                    validationEmail.AllowBlank = true;
                    validationEmail.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Personid	
                    var columnPersonid = worksheetImport.Names["Personid"];
                    var validationPersonid = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPersonid.Start.Column, rowLimit, columnPersonid.End.Column].Address);
                    validationPersonid.Error = "Personid length should 8 characters.";
                    validationPersonid.ShowErrorMessage = true;
                    validationPersonid.Formula.Value = 8;
                    validationPersonid.AllowBlank = true;
                    validationPersonid.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Metaid	
                    var columnMetaid = worksheetImport.Names["Metaid"];
                    var validationMetaid = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnMetaid.Start.Column, rowLimit, columnMetaid.End.Column].Address);
                    validationMetaid.Error = "Metaid length should 20 characters.";
                    validationMetaid.ShowErrorMessage = true;
                    validationMetaid.Formula.Value = 20;
                    validationMetaid.AllowBlank = true;
                    validationMetaid.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Address1	
                    var columnAddress1 = worksheetImport.Names["Address1"];
                    var validationAddress1 = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAddress1.Start.Column, rowLimit, columnAddress1.End.Column].Address);
                    validationAddress1.Error = "Address1 length should 50 characters.";
                    validationAddress1.ShowErrorMessage = true;
                    validationAddress1.Formula.Value = 50;
                    validationAddress1.AllowBlank = true;
                    validationAddress1.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Address2	
                    var columnAddress2 = worksheetImport.Names["Address2"];
                    var validationAddress2 = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAddress2.Start.Column, rowLimit, columnAddress2.End.Column].Address);
                    validationAddress2.Error = "Address2 length should 50 characters.";
                    validationAddress2.ShowErrorMessage = true;
                    validationAddress2.Formula.Value = 50;
                    validationAddress2.AllowBlank = true;
                    validationAddress2.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Address3	
                    var columnAddress3 = worksheetImport.Names["Address3"];
                    var validationAddress3 = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAddress3.Start.Column, rowLimit, columnAddress3.End.Column].Address);
                    validationAddress3.Error = "Address3 length should 50 characters.";
                    validationAddress3.ShowErrorMessage = true;
                    validationAddress3.Formula.Value = 50;
                    validationAddress3.AllowBlank = true;
                    validationAddress3.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Address4	
                    var columnAddress4 = worksheetImport.Names["Address4"];
                    var validationAddress4 = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAddress4.Start.Column, rowLimit, columnAddress4.End.Column].Address);
                    validationAddress4.Error = "Address4 length should 50 characters.";
                    validationAddress4.ShowErrorMessage = true;
                    validationAddress4.Formula.Value = 50;
                    validationAddress4.AllowBlank = true;
                    validationAddress4.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Pin	
                    var columnPincode = worksheetImport.Names["Pincode"];
                    var validationPincode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPincode.Start.Column, rowLimit, columnPincode.End.Column].Address);
                    validationPincode.Error = "Pincode length should 6 characters.";
                    validationPincode.ShowErrorMessage = true;
                    validationPincode.Formula.Value = 6;
                    validationPincode.AllowBlank = true;
                    validationPincode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Aadharno	
                    var columnAadharno = worksheetImport.Names["Aadharno"];
                    var validationAadharno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnAadharno.Start.Column, rowLimit, columnAadharno.End.Column].Address);
                    validationAadharno.Error = "Aadharno length should 12 characters.";
                    validationAadharno.ShowErrorMessage = true;
                    validationAadharno.Formula.Value = 12;
                    validationAadharno.AllowBlank = true;
                    validationAadharno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Bankcode	
                    var columnBankcode = worksheetImport.Names["Bankcode"];
                    var validationBankcode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnBankcode.Start.Column, rowLimit, columnBankcode.End.Column].Address);
                    validationBankcode.Error = "Bankcode length should 3 characters.";
                    validationBankcode.ShowErrorMessage = true;
                    validationBankcode.Formula.Value = 3;
                    validationBankcode.AllowBlank = true;
                    validationBankcode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Dol	
                    var columnDol = worksheetImport.Names["Dol"];
                    var validationDol = worksheetImport.DataValidations.AddDateTimeValidation(worksheetImport.Cells[2, columnDol.Start.Column, rowLimit, columnDol.End.Column].Address);
                    validationDol.Error = "Dol should not be later today";
                    validationDol.ShowErrorMessage = true;
                    validationDol.Formula.ExcelFormula = "TODAY()";
                    validationDol.AllowBlank = true;
                    validationDol.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Emp_Hod	
                    var columnEmpHod = worksheetImport.Names["EmpHod"];
                    var validationEmpHod = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnEmpHod.Start.Column, rowLimit, columnEmpHod.End.Column].Address);
                    validationEmpHod.Error = "EmpHod length should 5 characters.";
                    validationEmpHod.ShowErrorMessage = true;
                    validationEmpHod.Formula.Value = 5;
                    validationEmpHod.AllowBlank = true;
                    validationEmpHod.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Expbefore	
                    var columnExpbefore = worksheetImport.Names["Expbefore"];
                    var validationExpbefore = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnExpbefore.Start.Column, rowLimit, columnExpbefore.End.Column].Address);
                    validationExpbefore.Error = "Expbefore length should 5 characters.";
                    validationExpbefore.ShowErrorMessage = true;
                    validationExpbefore.Formula.Value = 5;
                    validationExpbefore.AllowBlank = true;
                    validationExpbefore.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Gradyear	
                    var columnGradyear = worksheetImport.Names["Gradyear"];
                    var validationGradyear = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnGradyear.Start.Column, rowLimit, columnGradyear.End.Column].Address);
                    validationGradyear.Error = "Gradyear length should 4 characters.";
                    validationGradyear.ShowErrorMessage = true;
                    validationGradyear.Formula.Value = 4;
                    validationGradyear.AllowBlank = true;
                    validationGradyear.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Graduation	
                    var columnGraduation = worksheetImport.Names["Graduation"];
                    var validationGraduation = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnGraduation.Start.Column, rowLimit, columnGraduation.End.Column].Address);
                    validationGraduation.Error = "Graduation length should 15 characters.";
                    validationGraduation.ShowErrorMessage = true;
                    validationGraduation.Formula.Value = 15;
                    validationGraduation.AllowBlank = true;
                    validationGraduation.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Gratutityno	
                    var columnGratutityno = worksheetImport.Names["Gratutityno"];
                    var validationGratutityno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnGratutityno.Start.Column, rowLimit, columnGratutityno.End.Column].Address);
                    validationGratutityno.Error = "Gratutityno length should 18 characters.";
                    validationGratutityno.ShowErrorMessage = true;
                    validationGratutityno.Formula.Value = 18;
                    validationGratutityno.AllowBlank = true;
                    validationGratutityno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Itno	
                    var columnItno = worksheetImport.Names["Itno"];
                    var validationItno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnItno.Start.Column, rowLimit, columnItno.End.Column].Address);
                    validationItno.Error = "Itno length should 10 characters.";
                    validationItno.ShowErrorMessage = true;
                    validationItno.Formula.Value = 10;
                    validationItno.AllowBlank = true;
                    validationItno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Mngr	
                    var columnMngr = worksheetImport.Names["Mngr"];
                    var validationMngr = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnMngr.Start.Column, rowLimit, columnMngr.End.Column].Address);
                    validationMngr.Error = "Mngr length should 5 characters.";
                    validationMngr.ShowErrorMessage = true;
                    validationMngr.Formula.Value = 5;
                    validationMngr.AllowBlank = true;
                    validationMngr.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Pensionno	
                    var columnPensionno = worksheetImport.Names["Pensionno"];
                    var validationPensionno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPensionno.Start.Column, rowLimit, columnPensionno.End.Column].Address);
                    validationPensionno.Error = "Pensionno length should 20 characters.";
                    validationPensionno.ShowErrorMessage = true;
                    validationPensionno.Formula.Value = 20;
                    validationPensionno.AllowBlank = true;
                    validationPensionno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Pfno	
                    var columnPfno = worksheetImport.Names["Pfno"];
                    var validationPfno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPfno.Start.Column, rowLimit, columnPfno.End.Column].Address);
                    validationPfno.Error = "Pfno length should 22 characters.";
                    validationPfno.ShowErrorMessage = true;
                    validationPfno.Formula.Value = 22;
                    validationPfno.AllowBlank = true;
                    validationPfno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Reasonid	
                    var columnReasonid = worksheetImport.Names["Reasonid"];
                    var validationReasonid = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnReasonid.Start.Column, rowLimit, columnReasonid.End.Column].Address);
                    validationReasonid.Error = "Reasonid length should 3 characters.";
                    validationReasonid.ShowErrorMessage = true;
                    validationReasonid.Formula.Value = 3;
                    validationReasonid.AllowBlank = true;
                    validationReasonid.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Remarks	
                    var columnRemarks = worksheetImport.Names["Remarks"];
                    var validationRemarks = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnRemarks.Start.Column, rowLimit, columnRemarks.End.Column].Address);
                    validationRemarks.Error = "Remarks length should 200 characters.";
                    validationRemarks.ShowErrorMessage = true;
                    validationRemarks.Formula.Value = 200;
                    validationRemarks.AllowBlank = true;
                    validationRemarks.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Qual_Group	
                    var columnQualGroup = worksheetImport.Names["QualGroup"];
                    var validationQualGroup = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnQualGroup.Start.Column, rowLimit, columnQualGroup.End.Column].Address);
                    validationQualGroup.Error = "QualGroup length should 1 characters.";
                    validationQualGroup.ShowErrorMessage = true;
                    validationQualGroup.Formula.Value = 1;
                    validationQualGroup.AllowBlank = true;
                    validationQualGroup.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Superannuationno	
                    var columnSuperannuationno = worksheetImport.Names["Superannuationno"];
                    var validationSuperannuationno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnSuperannuationno.Start.Column, rowLimit, columnSuperannuationno.End.Column].Address);
                    validationSuperannuationno.Error = "Superannuationno length should 15 characters.";
                    validationSuperannuationno.ShowErrorMessage = true;
                    validationSuperannuationno.Formula.Value = 15;
                    validationSuperannuationno.AllowBlank = true;
                    validationSuperannuationno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Uanno	
                    var columnUanno = worksheetImport.Names["Uanno"];
                    var validationUanno = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnUanno.Start.Column, rowLimit, columnUanno.End.Column].Address);
                    validationUanno.Error = "Uanno length should 12 characters.";
                    validationUanno.ShowErrorMessage = true;
                    validationUanno.Formula.Value = 12;
                    validationUanno.AllowBlank = true;
                    validationUanno.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Place	
                    var columnPlace = worksheetImport.Names["Place"];
                    var validationPlace = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPlace.Start.Column, rowLimit, columnPlace.End.Column].Address);
                    validationPlace.Error = "Place length should 50 characters.";
                    validationPlace.ShowErrorMessage = true;
                    validationPlace.Formula.Value = 50;
                    validationPlace.AllowBlank = true;
                    validationPlace.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Payroll	
                    var columnPayroll = worksheetImport.Names["Payroll"];
                    var validationPayroll = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnPayroll.Start.Column, rowLimit, columnPayroll.End.Column].Address);
                    validationPayroll.Error = "Payroll length should 1 character.";
                    validationPayroll.ShowErrorMessage = true;
                    validationPayroll.Formula.Value = 1;
                    validationPayroll.AllowBlank = true;
                    validationPayroll.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Submit	
                    var columnSubmit = worksheetImport.Names["Submit"];
                    var validationSubmit = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnSubmit.Start.Column, rowLimit, columnSubmit.End.Column].Address);
                    validationSubmit.Error = "Submit length should 1 character.";
                    validationSubmit.ShowErrorMessage = true;
                    validationSubmit.Formula.Value = 1;
                    validationSubmit.AllowBlank = true;
                    validationSubmit.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Qualification_Id	
                    var columnQualificationid = worksheetImport.Names["QualificationId"];
                    var validationQualificationid = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnQualificationid.Start.Column, rowLimit, columnQualificationid.End.Column].Address);
                    validationQualificationid.Error = "Qualificationid length should 3 characters.";
                    validationQualificationid.ShowErrorMessage = true;
                    validationQualificationid.Formula.Value = 3;
                    validationQualificationid.AllowBlank = true;
                    validationQualificationid.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Dept_Code	
                    var columnDeptCode = worksheetImport.Names["DeptCode"];
                    var validationDeptCode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnDeptCode.Start.Column, rowLimit, columnDeptCode.End.Column].Address);
                    validationDeptCode.Error = "DeptCode length should 2 characters.";
                    validationDeptCode.ShowErrorMessage = true;
                    validationDeptCode.Formula.Value = 2;
                    validationDeptCode.AllowBlank = true;
                    validationDeptCode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Jobcategory	
                    var columnJobcategory = worksheetImport.Names["Jobcategory"];
                    var validationJobcategory = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnJobcategory.Start.Column, rowLimit, columnJobcategory.End.Column].Address);
                    validationJobcategory.Error = "Jobcategory length should 5 characters.";
                    validationJobcategory.ShowErrorMessage = true;
                    validationJobcategory.Formula.Value = 5;
                    validationJobcategory.AllowBlank = true;
                    validationJobcategory.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Job_Group_Code	
                    var columnJobGroupCode = worksheetImport.Names["JobGroupCode"];
                    var validationJobGroupCode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnJobGroupCode.Start.Column, rowLimit, columnJobGroupCode.End.Column].Address);
                    validationJobGroupCode.Error = "JobGroupCode length should 8 characters.";
                    validationJobGroupCode.ShowErrorMessage = true;
                    validationJobGroupCode.Formula.Value = 8;
                    validationJobGroupCode.AllowBlank = true;
                    validationJobGroupCode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Job_Discipline_Code
                    var columnJobDisciplineCode = worksheetImport.Names["JobDisciplineCode"];
                    var validationJobDisciplineCode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnJobDisciplineCode.Start.Column, rowLimit, columnJobDisciplineCode.End.Column].Address);
                    validationJobDisciplineCode.Error = "JobDisciplineCode length should 8 characters.";
                    validationJobDisciplineCode.ShowErrorMessage = true;
                    validationJobDisciplineCode.Formula.Value = 8;
                    validationJobDisciplineCode.AllowBlank = true;
                    validationJobDisciplineCode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    //Jobtitle_Code
                    var columnJobtitleCode = worksheetImport.Names["JobtitleCode"];
                    var validationJobtitleCode = worksheetImport.DataValidations.AddTextLengthValidation(worksheetImport.Cells[2, columnJobtitleCode.Start.Column, rowLimit, columnJobtitleCode.End.Column].Address);
                    validationJobtitleCode.Error = "JobtitleCode length should 8 characters.";
                    validationJobtitleCode.ShowErrorMessage = true;
                    validationJobtitleCode.Formula.Value = 8;
                    validationJobtitleCode.AllowBlank = true;
                    validationJobtitleCode.Operator = ExcelDataValidationOperator.lessThanOrEqual;

                    workbook.Worksheets["Dictionary"].Hidden = eWorkSheetHidden.Hidden;

                    excelPackage.Save();
                    ms.Position = 0;
                    return new MemoryStream(ms.ToArray());
                }
            }
        }

        public List<EmployeeCustom> ImportHRMastersCustom(Stream stream)
        {
            List<EmployeeCustom> employeeItems = new List<EmployeeCustom>();
            stream.Position = 0;
            using (ExcelPackage package = new ExcelPackage(stream))
            {
                var workbook = package.Workbook;
                var worksheet = workbook.Worksheets["Import"];

                if (worksheet == null)
                {
                    throw new Exception($"Worksheet 'Import' not found or in a bad status");
                }

                var props = typeof(EmployeeCustom).GetProperties();
                var rowIndex = 2;

                while (string.IsNullOrEmpty(worksheet.Cells[rowIndex, 1].GetValue<string>()) == false)
                {
                    var employeeCustom = new EmployeeCustom();
                    foreach (var prop in props)
                    {                        
                        var column = worksheet.Names[prop.Name];
                        var type = employeeCustom.GetType();
                        var pinfo = type.GetProperty(prop.Name);

                        if (worksheet.Cells[rowIndex, column.Start.Column].Value != null)
                        {
                            if (worksheet.Cells[rowIndex, column.Start.Column].Value.GetType() == typeof(DateTime))
                            {
                                pinfo?.SetValue(employeeCustom, worksheet.Cells[rowIndex, column.Start.Column].Value);
                            }
                            else
                            {
                                pinfo?.SetValue(employeeCustom, Convert.ChangeType(worksheet.Cells[rowIndex, column.Start.Column].Value, Nullable.GetUnderlyingType(pinfo.PropertyType) ?? pinfo.PropertyType));
                            }
                        }                         
                    }
                    employeeItems.Add(employeeCustom);
                    rowIndex += 1;
                }
            }

            return employeeItems;
        }
    }
}
