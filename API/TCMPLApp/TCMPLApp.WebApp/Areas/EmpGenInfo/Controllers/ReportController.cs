using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.EmpGenInfo.Controllers
{
    //[Authorize]
    [Area("EmpGenInfo")]
    public class ReportController : BaseController
    {
        private const string ConstFilterNominationStatusIndex = "HRNominationStatusDetails";
        private const string ConstFilterGTLINominationStatusIndex = "HRGTLINominationStatusDetails";
        private const string ConstFilterExEmployeeNomineeIndex = "ExEmployeeNomineeDetails";
        private const string ConstFilterExEmployeeContactIndex = "ExEmployeeContactDetails";
        private readonly IConfiguration _configuration;
        private readonly IEmpPrimaryDetailsRepository _empPrimaryDetailsRepository;
        private readonly IGTLIDetailsDataTableListRepository _gtliDetailsDataTableListRepository;
        private readonly IEmpProFundDetailsDataTableListRepository _empProFundDetailsDataTableListRepository;
        private readonly IEmpPensionFundMarriedDetailsDataTableListRepository _empPensionFundMarriedDetailsDataTableListRepository;
        private readonly IEmpPensionFundDetailsDataTableListRepository _empPensionFundDetailsDataTableListRepository;
        private readonly IGratuityDetailsDataTableListRepository _gratuityDetailsDataTableListRepository;
        private readonly ISuperannuationDetailsDataTableListRepository _superannuationDetailsDataTableListRepository;
        private readonly INominationSubmitStatusDataTableListRepository _nominationSubmitStatusDataTableListRepository;
        private readonly IGTLINominationSubmitStatusDataTableListRepository _gTLINominationSubmitStatusDataTableListRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly INominationSubmitStatusRepository _nominationSubmitStatusRepository;
        private readonly IGTLINominationSubmitStatusRepository _gTLINominationSubmitStatusRepository;

        private readonly IHREmpNomineeDataTableListRepository _hREmpNomineeDataTableListRepository;
        private readonly IHREmpFamilyDataTableListRepository _hREmpFamilyDataTableListRepository;
        private readonly IHREmpMediclaimDataTableListRepository _hREmpMediclaimDataTableListRepository;
        private readonly IHREmpDetailsNotFilledDataTableListRepository _hREmpDetailsNotFilledDataTableListRepository;
        private readonly IHREmpDetailsAllDataTableListRepository _hREmpDetailsAllDataTableListRepository;
        private readonly IHREmpAadhaarDataTableListRepository _hREmpAadhaarDataTableListRepository;
        private readonly IHRExEmpNomineeDataTableListRepository _hRExEmpNomineeDataTableListRepository;
        private readonly IHRExEmpContactInfoDataTableListRepository _hRExEmpContactInfoDataTableListRepository;

        public ReportController(IConfiguration configuration,
                      IEmpPrimaryDetailsRepository empPrimaryDetailsRepository,
                      IGTLIDetailsDataTableListRepository gtliDetailsDataTableListRepository,
                      IEmpProFundDetailsDataTableListRepository empProFundDetailsDataTableListRepository,
                      IEmpPensionFundMarriedDetailsDataTableListRepository empPensionFundMarriedDetailsDataTableListRepository,
                      IEmpPensionFundDetailsDataTableListRepository empPensionFundDetailsDataTableListRepository,
                      IGratuityDetailsDataTableListRepository gratuityDetailsDataTableListRepository,
                      ISuperannuationDetailsDataTableListRepository superannuationDetailsDataTableListRepository,
                      IFilterRepository filterRepository,
                      ISelectTcmPLRepository selectTcmPLRepository,
                      INominationSubmitStatusDataTableListRepository nominationSubmitStatusDataTableListRepository,
                      INominationSubmitStatusRepository nominationSubmitStatusRepository,
                      IUtilityRepository utilityRepository,
                      IGTLINominationSubmitStatusDataTableListRepository gTLINominationSubmitStatusDataTableListRepository,
                      IGTLINominationSubmitStatusRepository gTLINominationSubmitStatusRepository,
                      IHREmpNomineeDataTableListRepository hREmpNomineeDataTableListRepository,
                      IHREmpFamilyDataTableListRepository hREmpFamilyDataTableListRepository,
                      IHREmpMediclaimDataTableListRepository hREmpMediclaimDataTableListRepository,
                      IHREmpDetailsNotFilledDataTableListRepository hREmpDetailsNotFilledDataTableListRepository,
                      IHREmpDetailsAllDataTableListRepository hREmpDetailsAllDataTableListRepository,
                      IHREmpAadhaarDataTableListRepository hREmpAadhaarDataTableListRepository,
                      IHRExEmpNomineeDataTableListRepository hRExEmpNomineeDataTableListRepository,
                      IHRExEmpContactInfoDataTableListRepository hRExEmpContactInfoDataTableListRepository)
        {
            _configuration = configuration;
            _empPrimaryDetailsRepository = empPrimaryDetailsRepository;
            _gtliDetailsDataTableListRepository = gtliDetailsDataTableListRepository;
            _empProFundDetailsDataTableListRepository = empProFundDetailsDataTableListRepository;
            _empPensionFundMarriedDetailsDataTableListRepository = empPensionFundMarriedDetailsDataTableListRepository;
            _empPensionFundDetailsDataTableListRepository = empPensionFundDetailsDataTableListRepository;
            _gratuityDetailsDataTableListRepository = gratuityDetailsDataTableListRepository;
            _superannuationDetailsDataTableListRepository = superannuationDetailsDataTableListRepository;
            _filterRepository = filterRepository;
            _nominationSubmitStatusDataTableListRepository = nominationSubmitStatusDataTableListRepository;
            _utilityRepository = utilityRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _nominationSubmitStatusRepository = nominationSubmitStatusRepository;
            _gTLINominationSubmitStatusDataTableListRepository = gTLINominationSubmitStatusDataTableListRepository;
            _gTLINominationSubmitStatusRepository = gTLINominationSubmitStatusRepository;
            _hREmpNomineeDataTableListRepository = hREmpNomineeDataTableListRepository;
            _hREmpFamilyDataTableListRepository = hREmpFamilyDataTableListRepository;
            _hREmpMediclaimDataTableListRepository = hREmpMediclaimDataTableListRepository;
            _hREmpDetailsNotFilledDataTableListRepository = hREmpDetailsNotFilledDataTableListRepository;
            _hREmpDetailsAllDataTableListRepository = hREmpDetailsAllDataTableListRepository;
            _hREmpAadhaarDataTableListRepository = hREmpAadhaarDataTableListRepository;
            _hRExEmpNomineeDataTableListRepository = hRExEmpNomineeDataTableListRepository;
            _hRExEmpContactInfoDataTableListRepository = hRExEmpContactInfoDataTableListRepository;
        }

        [HttpGet]
        public async Task<IActionResult> DownloadGTLI(string id)
        {
            try
            {
                string strFileName;
                MemoryStream outputStream = new MemoryStream();

                UserIdentity currentUserIdentity = CurrentUserIdentity;
                if (string.IsNullOrEmpty(id))
                    id = currentUserIdentity.EmpNo;

                #region Get data from db

                var gtliList = await _gtliDetailsDataTableListRepository.HRGTLIDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                var empPrimaryDetail = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    });

                #endregion Get data from db

                var baseRepository = _configuration["TCMPLAppBaseRepository"];
                // var areaRepository = _configuration["AreaRepository:EmployeeGeneralInfo"];
                var areaRepository = Path.Combine(_configuration["TCMPLAppTemplatesRepository"], _configuration["AreaRepository:EmployeeGeneralInfo"]);

                var folder = Path.Combine(baseRepository, areaRepository);
                string docPath = Path.Combine(folder, "GTLI.docx");

                int[,] aryTable1 = new int[,] { { 1, 3 }, { 1, 3 }, { 1, 3 } };
                int[,] aryTable3 = new int[,] { { 1, 3 }, { 1, 3 } };

                byte[] templateBytes = System.IO.File.ReadAllBytes(docPath);

                using (MemoryStream templateStream = new MemoryStream())
                {
                    templateStream.Write(templateBytes, 0, templateBytes.Length);
                    using (WordprocessingDocument doc = WordprocessingDocument.Open(templateStream, true))
                    {
                        // Empno

                        #region Table0

                        Table table0 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(0);
                        TableRow table0Row = table0.Elements<TableRow>().ElementAt(0);
                        TableCell table0Cell = table0Row.Elements<TableCell>().ElementAt(1);
                        Paragraph table0P = table0Cell.Elements<Paragraph>().First();
                        Run table0R = table0P.Elements<Run>().First();
                        Text table0T = table0R.Elements<Text>().First();
                        table0T.Text = gtliList.FirstOrDefault().Empno;

                        #endregion Table0

                        //List

                        #region Table1

                        if (gtliList.Count() > 0)
                        {
                            Table table1 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(1);
                            for (int i = 1; i <= gtliList.Count(); i++)
                            {
                                TableRow row = table1.Elements<TableRow>().ElementAt(i);
                                if (gtliList.Count() > 8)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table1.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 6; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = gtliList.ElementAt(i - 1).NomName;
                                    else if (j == 1)
                                        t.Text = gtliList.ElementAt(i - 1).NomAdd1;
                                    else if (j == 2)
                                        t.Text = gtliList.ElementAt(i - 1).Relation;
                                    else if (j == 3)
                                        t.Text = gtliList.ElementAt(i - 1).NomDob;
                                    else if (j == 4)
                                        t.Text = gtliList.ElementAt(i - 1).SharePcnt;
                                    else if (j == 5)
                                    {
                                        if (!string.IsNullOrEmpty(gtliList.ElementAt(i - 1).NomMinorGuardName))
                                        {
                                            var text = "Name - " + gtliList.ElementAt(i - 1).NomMinorGuardName + Environment.NewLine;
                                            text = text + "Relation - " + gtliList.ElementAt(i - 1).NomMinorGuardRelation + Environment.NewLine;
                                            text = text + "Address - " + gtliList.ElementAt(i - 1).NomMinorGuardAdd1;

                                            string[] newLineArray = { Environment.NewLine };
                                            string[] textArray = text.Split(newLineArray, StringSplitOptions.None);

                                            bool first = true;

                                            foreach (string line in textArray)
                                            {
                                                if (!first)
                                                {
                                                    r.Append(new Break());
                                                }

                                                first = false;
                                                Text txt = new Text();
                                                txt.Text = line;
                                                r.Append(txt);
                                                t.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        #endregion Table1

                        //Emp details

                        #region Table2

                        Table table2 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(2);
                        for (int i = 0; i <= 4; i++)
                        {
                            TableRow row = table2.Elements<TableRow>().ElementAt(i);
                            for (int j = 1; j < 4; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 0 & j == 1)
                                {
                                    if (empPrimaryDetail.PNoDadHusbInName == "1")
                                        t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                                    else
                                        t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;

                                    break;
                                }
                                else if (i == 1 & j == 1)
                                {
                                    t.Text = empPrimaryDetail.PFatherName;
                                    break;
                                }
                                else if (i == 2)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PDob;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PGender;
                                        break;
                                    }
                                }
                                else if (i == 3)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PMaritalStatus;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PReligion;
                                        break;
                                    }
                                }
                                else if (i == 4 & j == 1)
                                {
                                    t.Text = empPrimaryDetail.PPAdd;
                                    break;
                                }
                            }
                        }

                        #endregion Table2

                        doc.Clone(outputStream);
                    }

                    strFileName = "GTLI_" + id + ".docx";

                    return File(outputStream.ToArray(),
                                        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                        strFileName);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> DownloadNomination(string id)
        {
            string text = null;
            string[] newLineArray = { Environment.NewLine };
            bool first = true;
            string[] textArray;
            try
            {
                string strFileName;
                MemoryStream outputStream = new MemoryStream();

                UserIdentity currentUserIdentity = CurrentUserIdentity;
                if (string.IsNullOrEmpty(id))
                    id = currentUserIdentity.EmpNo;

                #region Get data from db

                var empPrimaryDetail = await _empPrimaryDetailsRepository.HREmpPrimaryDetailsAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    });

                var pfList = await _empProFundDetailsDataTableListRepository.HREmpProFundDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                var penMarList = await _empPensionFundMarriedDetailsDataTableListRepository.HREmpPensionFundMarriedDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                var penList = await _empPensionFundDetailsDataTableListRepository.HREmpPensionFundDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                var gratuityList = await _gratuityDetailsDataTableListRepository.HRGratuityDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                var superAnnuationList = await _superannuationDetailsDataTableListRepository.HRSuperannuationDetailsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                #endregion Get data from db

                var baseRepository = _configuration["TCMPLAppBaseRepository"];
                //var areaRepository = _configuration["AreaRepository:EmployeeGeneralInfo"];
                var areaRepository = Path.Combine(_configuration["TCMPLAppTemplatesRepository"], _configuration["AreaRepository:EmployeeGeneralInfo"]);

                var folder = Path.Combine(baseRepository, areaRepository);
                string docPath = Path.Combine(folder, "Nomination.docx");

                int[,] aryTable1 = new int[,] { { 1, 3 }, { 1, 3 }, { 1, 3 } };
                int[,] aryTable3 = new int[,] { { 1, 3 }, { 1, 3 } };

                byte[] templateBytes = System.IO.File.ReadAllBytes(docPath);

                using (MemoryStream templateStream = new MemoryStream())
                {
                    templateStream.Write(templateBytes, 0, templateBytes.Length);
                    using (WordprocessingDocument doc = WordprocessingDocument.Open(templateStream, true))
                    {
                        //Empno

                        #region Table0

                        Table table0 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(0);
                        TableRow table0Row = table0.Elements<TableRow>().ElementAt(0);
                        TableCell table0Cell = table0Row.Elements<TableCell>().ElementAt(1);
                        Paragraph table0P = table0Cell.Elements<Paragraph>().First();
                        Run table0R = table0P.Elements<Run>().First();
                        Text table0T = table0R.Elements<Text>().First();
                        table0T.Text = pfList.FirstOrDefault().Empno;

                        #endregion Table0

                        //Emp details

                        #region Table1

                        Table table1 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(1);
                        for (int i = 0; i <= 5; i++)
                        {
                            TableRow row = table1.Elements<TableRow>().ElementAt(i);
                            for (int j = 1; j < 4; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 0 & j == 1)
                                {
                                    if (empPrimaryDetail.PNoDadHusbInName == "1")
                                        t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                                    else
                                        t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;

                                    break;
                                }
                                else if (i == 1 & j == 1)
                                {
                                    t.Text = empPrimaryDetail.PFatherName;
                                    break;
                                }
                                else if (i == 2)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PDob;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PGender;
                                        break;
                                    }
                                }
                                else if (i == 3)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PMaritalStatus;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PReligion;
                                        break;
                                    }
                                }
                                else if (i == 4 & j == 1)
                                {
                                    t.Text = empPrimaryDetail.PPAdd;
                                    break;
                                }
                                else if (i == 5)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PDoj.Value.ToString("dd-MMM-yyyy");
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PAssign + " - " + empPrimaryDetail.PAssignName;
                                        break;
                                    }
                                }
                            }
                        }

                        #endregion Table1

                        //EPF List

                        #region Table2

                        if (pfList.Count() > 0)
                        {
                            Table table2 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(2);
                            for (int i = 2; i <= pfList.Count() + 1; i++)
                            {
                                TableRow row = table2.Elements<TableRow>().ElementAt(i);
                                if (pfList.Count() > 8)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table1.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 6; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = pfList.ElementAt(i - 2).NomName;
                                    else if (j == 1)
                                        t.Text = pfList.ElementAt(i - 2).NomAdd1;
                                    else if (j == 2)
                                        t.Text = pfList.ElementAt(i - 2).Relation;
                                    else if (j == 3)
                                        t.Text = pfList.ElementAt(i - 2).NomDob;
                                    else if (j == 4)
                                        t.Text = pfList.ElementAt(i - 2).SharePcnt;
                                    else if (j == 5)
                                    {
                                        if (!string.IsNullOrEmpty(pfList.ElementAt(i - 2).GuardianName))
                                        {
                                            text = "Name - " + pfList.ElementAt(i - 2).GuardianName + Environment.NewLine;
                                            text = text + "Relation - " + pfList.ElementAt(i - 2).GuardianRelation + Environment.NewLine;
                                            text = text + "Address - " + pfList.ElementAt(i - 2).GuardianAddress;

                                            textArray = text.Split(newLineArray, StringSplitOptions.None);

                                            foreach (string line in textArray)
                                            {
                                                if (!first)
                                                {
                                                    r.Append(new Break());
                                                }

                                                first = false;
                                                Text txt = new Text();
                                                txt.Text = line;
                                                r.Append(txt);
                                                t.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        #endregion Table2

                        //EPS Married List

                        #region Table3

                        if (penMarList.Count() > 0)
                        {
                            Table table3 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(3);
                            for (int i = 1; i <= penMarList.Count(); i++)
                            {
                                TableRow row = table3.Elements<TableRow>().ElementAt(i);
                                if (penMarList.Count() > 5)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table1.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 4; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = penMarList.ElementAt(i - 1).NomName;
                                    else if (j == 1)
                                        t.Text = penMarList.ElementAt(i - 1).NomAdd1;
                                    else if (j == 2)
                                        t.Text = penMarList.ElementAt(i - 1).NomDob;
                                    else if (j == 3)
                                        t.Text = penMarList.ElementAt(i - 1).Relation;
                                }
                            }
                        }

                        #endregion Table3

                        //EPS List

                        #region Table4

                        if (penList.Count() > 0)
                        {
                            Table table4 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(4);
                            for (int i = 1; i <= penList.Count(); i++)
                            {
                                TableRow row = table4.Elements<TableRow>().ElementAt(i);
                                if (penList.Count() > 5)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table1.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 4; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = penList.ElementAt(i - 1).NomName;
                                    else if (j == 1)
                                        t.Text = penList.ElementAt(i - 1).NomAdd1;
                                    else if (j == 2)
                                        t.Text = penList.ElementAt(i - 1).NomDob;
                                    else if (j == 3)
                                        t.Text = penList.ElementAt(i - 1).Relation;
                                }
                            }
                        }

                        #endregion Table4

                        //EPS Certificate by employer

                        #region Table5

                        Table table5 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(5);
                        TableRow table5Row = table5.Elements<TableRow>().ElementAt(0);
                        TableCell table5Cell = table5Row.Elements<TableCell>().ElementAt(0);
                        Paragraph table5P = table5Cell.Elements<Paragraph>().First();
                        Run table5R = table5P.Elements<Run>().First();
                        Text table5T = table5R.Elements<Text>().First();
                        text = "CERTIFIED that the above declaration and nomination has been signed / thumb impressed before me by " + Environment.NewLine;
                        text = text + "Shri / Smt. / Kum. ";
                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                        else
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;

                        text = text + ", employed in our establishment after he / she has read the entries / entries have read " + Environment.NewLine;
                        text = text + "over to him / her by me and got confirmed by him / her.";

                        textArray = text.Split(newLineArray, StringSplitOptions.None);

                        foreach (string line in textArray)
                        {
                            if (!first)
                            {
                                table5R.Append(new Break());
                            }

                            first = false;
                            Text txt = new Text();
                            txt.Text = line;
                            table5R.Append(txt);
                            table5T.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                        }

                        #endregion Table5

                        //Gratuity

                        #region Table6

                        Table table6 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(7);
                        TableRow table6Row = table6.Elements<TableRow>().ElementAt(0);
                        TableCell table6Cell = table6Row.Elements<TableCell>().ElementAt(0);
                        Paragraph table6P = table6Cell.Elements<Paragraph>().First();
                        Run table6R = table6P.Elements<Run>().First();
                        Text table6T = table6R.Elements<Text>().First();
                        text = "Dear Sirs" + Environment.NewLine + Environment.NewLine;
                        text = text + "I, ";
                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                        else
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;
                        text = text + ", a member of Tecnimont Pvt Ltd Employees Group Gratuity cum Life" + Environment.NewLine;
                        text = text + "Assurance Scheme here by agree to abide by the rules of the said Scheme and do also hereby appoint in terms of Rule 22 to " + Environment.NewLine;
                        text = text + "the Rules the Beneficiary / ies Nominee / s mentioned hereunder to receive the benefits, payable under the Scheme, in the " + Environment.NewLine;
                        text = text + "event of death before the amount becomes payable has not been paid.I hereby direct that the benefits under the Scheme, " + Environment.NewLine;
                        text = text + "payable in respect of me, shall be paid to the said Beneficiary/ies Nominee/s in proportion indicated against their respective " + Environment.NewLine;
                        text = text + "names as given below :";

                        textArray = text.Split(newLineArray, StringSplitOptions.None);

                        foreach (string line in textArray)
                        {
                            if (!first)
                            {
                                table6R.Append(new Break());
                            }

                            first = false;
                            Text txt = new Text();
                            txt.Text = line;
                            table6R.Append(txt);
                            table6T.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                        }

                        #endregion Table6

                        //Gratuity List

                        #region Table7

                        if (gratuityList.Count() > 0)
                        {
                            Table table7 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(8);
                            for (int i = 1; i <= gratuityList.Count(); i++)
                            {
                                TableRow row = table7.Elements<TableRow>().ElementAt(i);
                                if (gratuityList.Count() > 6)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table1.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 5; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = gratuityList.ElementAt(i - 1).NomName;
                                    else if (j == 1)
                                        t.Text = gratuityList.ElementAt(i - 1).NomAdd1;
                                    else if (j == 2)
                                        t.Text = gratuityList.ElementAt(i - 1).Relation;
                                    else if (j == 3)
                                        t.Text = gratuityList.ElementAt(i - 1).NomDob;
                                    else if (j == 4)
                                        t.Text = gratuityList.ElementAt(i - 1).SharePcnt;
                                }
                            }
                        }

                        #endregion Table7

                        //Gratuity Emp details

                        #region Table8

                        Table table8 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(9);
                        for (int i = 0; i <= 4; i++)
                        {
                            TableRow row = table8.Elements<TableRow>().ElementAt(i);
                            for (int j = 1; j < 4; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 0)
                                {
                                    if (j == 1)
                                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                                            t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                                        else
                                            t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PGender;
                                        break;
                                    }
                                }
                                else if (i == 1)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PFatherName;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PDob;
                                        break;
                                    }
                                }
                                else if (i == 2)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PMaritalStatus;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PReligion;
                                        break;
                                    }
                                }
                                else if (i == 3 & j == 1)
                                {
                                    t.Text = empPrimaryDetail.PPAdd;
                                    break;
                                }
                                else if (i == 4)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PDoj.Value.ToString("dd-MMM-yyyy");
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PDoj.Value.ToString("dd-MMM-yyyy");
                                        break;
                                    }
                                }
                            }
                        }

                        #endregion Table8

                        //Gratuity witness

                        #region Table9

                        Table table9 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(10);
                        TableRow table9Row = table9.Elements<TableRow>().ElementAt(0);
                        TableCell table9Cell = table9Row.Elements<TableCell>().ElementAt(0);
                        Paragraph table9P = table9Cell.Elements<Paragraph>().First();
                        Run table9R = table9P.Elements<Run>().First();
                        Text table9T = table9R.Elements<Text>().First();
                        text = "Certified that the above appointment of Beneficiary has been signed by Shri/ Shrimati ";

                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname + Environment.NewLine;
                        else
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname + Environment.NewLine;

                        text = text + "before me after he/ she has read the entries, the entries have been read to him/ her by me and after the said appointment of " + Environment.NewLine;
                        text = text + "Beneficiary is recorded under the scheme on";

                        textArray = text.Split(newLineArray, StringSplitOptions.None);

                        foreach (string line in textArray)
                        {
                            if (!first)
                            {
                                table9R.Append(new Break());
                            }

                            first = false;
                            Text txt = new Text();
                            txt.Text = line;
                            table9R.Append(txt);
                            table9T.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                        }

                        #endregion Table9

                        //Superannuation

                        #region Table10

                        Table table10 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(11);
                        TableRow table10Row = table10.Elements<TableRow>().ElementAt(0);
                        TableCell table10Cell = table10Row.Elements<TableCell>().ElementAt(0);
                        Paragraph table10P = table10Cell.Elements<Paragraph>().First();
                        Run table10R = table10P.Elements<Run>().First();
                        Text table10T = table10R.Elements<Text>().First();
                        text = "Dear Sirs" + Environment.NewLine + Environment.NewLine;
                        text = text + "I, ";

                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                        else
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;

                        text = text + ", a member of Tecnimont Pvt Ltd Employees Superannuation Scheme " + Environment.NewLine;
                        text = text + "hereby agree to abide by the rules of the said Scheme and do also hereby appoint in terms of Rules the Beneficiary / ies " + Environment.NewLine;
                        text = text + "mention hereunder to receive the benefits, payable under the Scheme, in the event of my death before the amount becomes " + Environment.NewLine;
                        text = text + "payable has not been paid." + Environment.NewLine;
                        text = text + "I hereby direct that the benefits under the Scheme, payable in respect of me, shall be paid to the said Beneficiary/ies in" + Environment.NewLine;
                        text = text + "proportion indicated against their respective names as given below:";

                        textArray = text.Split(newLineArray, StringSplitOptions.None);

                        foreach (string line in textArray)
                        {
                            if (!first)
                            {
                                table10R.Append(new Break());
                            }

                            first = false;
                            Text txt = new Text();
                            txt.Text = line;
                            table10R.Append(txt);
                            table10T.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                        }

                        #endregion Table10

                        //Superannuation List

                        #region Table11

                        if (superAnnuationList.Count() > 0)
                        {
                            Table table11 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(12);
                            for (int i = 1; i <= superAnnuationList.Count(); i++)
                            {
                                TableRow row = table11.Elements<TableRow>().ElementAt(i);
                                if (superAnnuationList.Count() > 6)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table1.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 5; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = superAnnuationList.ElementAt(i - 1).NomName;
                                    else if (j == 1)
                                        t.Text = superAnnuationList.ElementAt(i - 1).NomAdd1;
                                    else if (j == 2)
                                        t.Text = superAnnuationList.ElementAt(i - 1).Relation;
                                    else if (j == 3)
                                        t.Text = superAnnuationList.ElementAt(i - 1).NomDob;
                                    else if (j == 4)
                                        t.Text = superAnnuationList.ElementAt(i - 1).SharePcnt;
                                }
                            }
                        }

                        #endregion Table11

                        //Superannuation Emp details

                        #region Table12

                        Table table12 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(13);
                        for (int i = 0; i <= 4; i++)
                        {
                            TableRow row = table12.Elements<TableRow>().ElementAt(i);
                            for (int j = 1; j < 4; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 0)
                                {
                                    if (j == 1)
                                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                                            t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname;
                                        else
                                            t.Text = empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PGender;
                                        break;
                                    }
                                }
                                else if (i == 1)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PFatherName;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PDob;
                                        break;
                                    }
                                }
                                else if (i == 2)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PMaritalStatus;
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PReligion;
                                        break;
                                    }
                                }
                                else if (i == 3 & j == 1)
                                {
                                    t.Text = empPrimaryDetail.PPAdd;
                                    break;
                                }
                                else if (i == 4)
                                {
                                    if (j == 1)
                                        t.Text = empPrimaryDetail.PDoj.Value.ToString("dd-MMM-yyyy");
                                    else if (j == 3)
                                    {
                                        t.Text = empPrimaryDetail.PDoj.Value.ToString("dd-MMM-yyyy");
                                        break;
                                    }
                                }
                            }
                        }

                        #endregion Table12

                        //Superannuation witness

                        #region Table13

                        Table table13 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(14);
                        TableRow table13Row = table13.Elements<TableRow>().ElementAt(0);
                        TableCell table13Cell = table13Row.Elements<TableCell>().ElementAt(0);
                        Paragraph table13P = table13Cell.Elements<Paragraph>().First();
                        Run table13R = table13P.Elements<Run>().First();
                        Text table13T = table13R.Elements<Text>().First();
                        text = "Certified that the above appointment of Beneficiary has been signed by Shri/Shrimati ";

                        if (empPrimaryDetail.PNoDadHusbInName == "1")
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PSurname + Environment.NewLine;
                        else
                            text = text + empPrimaryDetail.PFirstName + " " + empPrimaryDetail.PFatherName + " " + empPrimaryDetail.PSurname + Environment.NewLine;

                        text = text + "before me after he/she has read the entries, the entries have been read to him/her by me and after the said appointment of " + Environment.NewLine;
                        text = text + "Beneficiary is recorded under the scheme on";

                        textArray = text.Split(newLineArray, StringSplitOptions.None);

                        foreach (string line in textArray)
                        {
                            if (!first)
                            {
                                table13R.Append(new Break());
                            }

                            first = false;
                            Text txt = new Text();
                            txt.Text = line;
                            table13R.Append(txt);
                            table13T.Text = txt.ToString().Replace("DocumentFormat.OpenXml.Wordprocessing.Text", "");
                        }

                        #endregion Table13

                        doc.Clone(outputStream);
                    }

                    strFileName = "Nomination_" + id + ".docx";

                    return File(outputStream.ToArray(),
                                        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                        strFileName);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #region HRNominationSubmitStatus

        public async Task<IActionResult> NominationSubmitStatusIndex()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterNominationStatusIndex
                });

                EmpNominationSubmitStatusViewModel empNominationSubmitStatusViewModel = new EmpNominationSubmitStatusViewModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    empNominationSubmitStatusViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                return View(empNominationSubmitStatusViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsNominationSubmitStatus(string paramJson)
        {
            DTResult<EmpNominationSubmitStatusDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<EmpNominationSubmitStatusDataTableList> data = await _nominationSubmitStatusDataTableListRepository.NominationSubmitStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PParent = param.Parent,
                        PSubmitStatus = param.SubmitStatus,
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> NominationSubmitStatusExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterNominationStatusIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Nomination Submit Status_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<EmpNominationSubmitStatusDataTableList> data = await _nominationSubmitStatusDataTableListRepository.NominationSubmitStatusDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<NominationSubmitStatusDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<NominationSubmitStatusDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Nomination Submit Status", "Nomination Submit Status");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> NominationSubmitStatusEdit(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _nominationSubmitStatusRepository.NominationSubmitStatusEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion HRNominationSubmitStatus

        #region HRGTLINominationSubmitStatus

        public async Task<IActionResult> GTLISubmitStatusIndex()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterGTLINominationStatusIndex
                });

                EmpGTLINominationSubmitStatusViewModel empGTLINominationSubmitStatusViewModel = new EmpGTLINominationSubmitStatusViewModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    empGTLINominationSubmitStatusViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                return View(empGTLINominationSubmitStatusViewModel);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsGTLINominationSubmitStatus(string paramJson)
        {
            DTResult<EmpGTLINominationSubmitStatusDataTableList> result = new();
            int totalRow = 0;
            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                System.Collections.Generic.IEnumerable<EmpGTLINominationSubmitStatusDataTableList> data = await _gTLINominationSubmitStatusDataTableListRepository.GTLINominationSubmitStatusDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
                        PParent = param.Parent,
                        PSubmitStatus = param.SubmitStatus,
                        PRowNumber = param.Start,
                        PPageLength = param.Length
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new { error = ex.Message });
            }
        }

        public async Task<IActionResult> GTLINominationSubmitStatusExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterGTLINominationStatusIndex
                });
                FilterDataModel filterDataModel = new FilterDataModel();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "GTLI Nomination Submit Status_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<EmpGTLINominationSubmitStatusDataTableList> data = await _gTLINominationSubmitStatusDataTableListRepository.GTLINominationSubmitStatusDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<GTLINominationSubmitStatusDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<GTLINominationSubmitStatusDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "GTLI Nomination Submit Status", "GTLI Nomination Submit Status");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> GTLINominationSubmitStatusEdit(string id)
        {
            try
            {
                Domain.Models.Common.DBProcMessageOutput result = await _gTLINominationSubmitStatusRepository.GTLINominationSubmitStatusEditAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = id
                    }
                    );

                return Json(new { success = result.PMessageType == IsOk, response = result.PMessageType, message = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion HRGTLINominationSubmitStatus

        #region Filter

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == IsOk, response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName,
                PFilterJson = jsonFilter
            });
            return retVal;
        }

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> NominationFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterNominationStatusIndex);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var parentList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);

            ViewData["ParentList"] = new SelectList(parentList, "DataValueField", "DataTextField");

            return PartialView("_ModalNominationSubmitStatusFilterSet", filterDataModel);
        }

        public async Task<IActionResult> GTLINominationFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterGTLINominationStatusIndex);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var parentList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);

            ViewData["ParentList"] = new SelectList(parentList, "DataValueField", "DataTextField");

            return PartialView("_ModalGTLINominationSubmitStatusFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> NominationFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Parent = filterDataModel.Parent,
                            SubmitStatus = filterDataModel.SubmitStatus,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterNominationStatusIndex);

                return Json(new
                {
                    success = true,
                    parent = filterDataModel.Parent,
                    submitStatus = filterDataModel.SubmitStatus,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpPost]
        public async Task<IActionResult> GTLINominationFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            Parent = filterDataModel.Parent,
                            SubmitStatus = filterDataModel.SubmitStatus,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterGTLINominationStatusIndex);

                return Json(new
                {
                    success = true,
                    parent = filterDataModel.Parent,
                    submitStatus = filterDataModel.SubmitStatus,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Filter

        #region HR - Employee General Info Reports

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeNomineeDetailsExcel()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Employee Nominee Details_" + timeStamp.ToString();
                string reportTitle = "Employee Nominee Details";
                string sheetName = "Employee Nominee Details";

                IEnumerable<HREmpNomineeDataTableList> data = await _hREmpNomineeDataTableListRepository.HREmpNomineeDataTableListAsync(
                                                                        BaseSpTcmPLGet(), new ParameterSpTcmPL { });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpNomineeDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpNomineeDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData,
                reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeFamilyDetailsExcel()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Employee Family Details_" + timeStamp.ToString();
                string reportTitle = "Employee Family Details";
                string sheetName = "Employee Family Details";

                IEnumerable<HREmpFamilyDataTableList> data = await _hREmpFamilyDataTableListRepository.HREmpFamilyDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpFamilyDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpFamilyDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeMediclaimDetailsExcel()
        {
            var retVal = await RetriveFilter(ConstFilterNominationStatusIndex);

            FilterDataModel filterDataModel = new FilterDataModel();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            var parentList = await _selectTcmPLRepository.CostCodeListAsync(BaseSpTcmPLGet(), null);

            ViewData["ParentList"] = new SelectList(parentList, "DataValueField", "DataTextField");

            return PartialView("_ModalMediclaimFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeMediclaimDetailsExcel(DateTime startDate, DateTime endDate)
        {
            try
            {

                if (startDate > endDate)
                    throw new Exception("End date should be greater than start date");
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Employee Mediclaim Details_" + timeStamp.ToString();
                string reportTitle = "Employee Mediclaim Details " + startDate.ToString("dd-MMM-yyyy") + " To " + endDate.ToString("dd-MMM-yyyy");
                string sheetName = "Employee Family Details";

                IEnumerable<HREmpMediclaimDataTableList> data = await _hREmpMediclaimDataTableListRepository.HREmpMediclaimDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PStartDate = startDate,
                        PEndDate = endDate,
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpMediclaimDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpMediclaimDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeDetailsNotFilledExcel()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Employee Details Not Filled_" + timeStamp.ToString();
                string reportTitle = "Employee Details Not Filled";
                string sheetName = "Employee Details Not Filled";

                IEnumerable<HREmpDetailsNotFilledDataTableList> data = await _hREmpDetailsNotFilledDataTableListRepository.HREmpDetailsNotFilledDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpDetailsNotFilledDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpDetailsNotFilledDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeDetailsAllExcel()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Employee Details_" + timeStamp.ToString();
                string reportTitle = "Employee Details";
                string sheetName = "Employee Details";

                IEnumerable<HREmpDetailsAllDataTableList> data = await _hREmpDetailsAllDataTableListRepository.HREmpDetailsAllDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpDetailsAllDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpDetailsAllDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> EmployeeAadhaarDetailsExcel()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Employee Aadhaar Details_" + timeStamp.ToString();
                string reportTitle = "Employee Aadhaar Details";
                string sheetName = "Employee Aadhaar Details";

                IEnumerable<HREmpAadhaarDataTableList> data = await _hREmpAadhaarDataTableListRepository.HREmpAadhaarDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<HREmpAadhaarDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HREmpAadhaarDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }


        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> Ex_EmployeeNomineeDetailsExcel()
        {
            var retVal = await RetriveFilter(ConstFilterExEmployeeNomineeIndex);

            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.StartDate = new DateTime(DateTime.Now.Year);
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalExEmployeeNomineeFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> Ex_EmployeeNomineeDetailsExcel(string selectYear, string empno)
        {
            try
            {
                if (selectYear == null && empno == null)
                {
                    throw new Exception("Please Select Any One Field.!");
                }
                var timeStamp = DateTime.Now.ToFileTime();

                string fileName = "Ex Employee Nominee Details_" + timeStamp.ToString();
                string reportTitle = "Ex Employee Nominee Details";
                string sheetName = "Ex Employee Nominee Details";

                if (empno != null)
                {
                    empno = MultilineToCSV(empno);
                    if (empno.Length == 0)
                    {
                        throw new Exception("Invalid Employee No");
                    }
                }

                IEnumerable<HRExEmpNomineeDataTableList> data = await _hRExEmpNomineeDataTableListRepository.HRExEmpNomineeDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYear = selectYear,
                        PEmpnoCsv = empno,
                    });

                if (data.Count() == 0) { throw new Exception("No Data Found"); }

                //var json = JsonConvert.SerializeObject(data);

                //IEnumerable<HRExEmpNomineeDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HRExEmpNomineeDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }


        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> Ex_EmployeeContactDetailsExcel()
        {
            var retVal = await RetriveFilter(ConstFilterExEmployeeContactIndex);

            FilterDataModel filterDataModel;
            if (string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = new FilterDataModel();
                filterDataModel.StartDate = new DateTime(DateTime.Now.Year);
            }
            else
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);

            return PartialView("_ModalExEmployeeContactFilterSet", filterDataModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, EmpGenInfoHelper.ActionEGIUpdateOnBehalf)]
        public async Task<IActionResult> Ex_EmployeeContactDetailsExcel(string selectYear, string empno)
        {
            try
            {
                if (selectYear == null && empno == null)
                {
                    throw new Exception("Please Select Any One Field.!");
                }
                var timeStamp = DateTime.Now.ToFileTime();
                
                string fileName = "Ex Employee Contact Details_" + timeStamp.ToString();
                string reportTitle = "Ex Employee Contact Details";
                string sheetName = "Ex Employee Contact Details";
                if(empno != null)
                {
                    empno = MultilineToCSV(empno);
                    if (empno.Length == 0)
                    {
                        throw new Exception("Invalid Employee No");
                    }
                } 
                
                IEnumerable<HRExEmpContactInfoDataTableList> data = await _hRExEmpContactInfoDataTableListRepository.HRExEmpContactInfoDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PYear = selectYear,
                        PEmpnoCsv = empno,
                    });

                if (data.Count() == 0) { throw new Exception("No Data Found"); }

                //var json = JsonConvert.SerializeObject(data);

                //IEnumerable<HRExEmpContactDetailsDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<HRExEmpContactDetailsDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, reportTitle, sheetName);

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            fileName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion HR - Employee General Info Reports

        #region StringManipulation
        public string MultilineToCSV(string sourceStr)
        {
            if (string.IsNullOrEmpty(sourceStr))
            {
                return ("");
            }
            bool s = !Regex.IsMatch(sourceStr, @"[^0-9A-Za-z, \r\n]");

            if(!s)
            {
                throw new Exception("Please Enter Valid Employee No");
            }
            string retVal = sourceStr.Replace(System.Environment.NewLine, ","); //add a line terminating ;
            retVal = Regex.Replace(retVal, @"\r\n?|\n", ",");
            return retVal;
        }

        public string InsertCharAtDividedPosition(string str, int count, string character)
        {
            var i = 0;
            while (++i * count + (i - 1) < str.Length)
            {
                str = str.Insert((i * count + (i - 1)), character);
            }
            return str;
        }
        #endregion StringManipulation
    }
}