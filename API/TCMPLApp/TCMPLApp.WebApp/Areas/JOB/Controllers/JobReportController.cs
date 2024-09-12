using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.JOB.Controllers
{
    //[Authorize]
    [Area("JOB")]
    public class JobReport : BaseController
    {
        private readonly string R01 = "R01";
        private readonly string R02 = "R02";
        private readonly string R03 = "R03";
        private readonly string R04 = "R04";
        private readonly string R05 = "R05";
        private readonly string R06 = "R06";
        private readonly string R07 = "R07";
        private readonly string R08 = "R08";

        private readonly IConfiguration _configuration;
        private readonly IUtilityRepository _utilityRepository;
        private readonly IJobmasterDetailRepository _jobmasterDetailRepository;
        private readonly IJobNotesDetailRepository _jobNotesDetailRepository;
        private readonly IJobPhaseDataTableListRepository _jobPhaseDataTableListRepository;
        private readonly IJobBudgetDataTableListRepository _jobBudgetDataTableListRepository;
        private readonly IJobMailListDataTableListRepository _jobMailListDataTableListRepository;
        private readonly IJobResponsibleApproversListRepository _jobResponsibleApproversListRepository;
        private readonly IJobResponsibleApproversDetailRepository _jobResponsibleApproversDetailRepository;
        private readonly IJobErpPhasesFileDetailRepository _jobErpPhasesFileDetailRepository;
        private readonly IJobApproverStatusDetailRepository _jobApproverStatusDetailRepository;
        private readonly IJobFormListReportExcelRepository _jobFormListReportExcelRepository;

        public JobReport(IConfiguration configuration,
                         IUtilityRepository utilityRepository,
                         IJobmasterDetailRepository jobmasterDetailRepository,
                         IJobNotesDetailRepository jobNotesDetailRepository,
                         IJobPhaseDataTableListRepository jobPhaseDataTableListRepository,
                         IJobBudgetDataTableListRepository jobBudgetDataTableListRepository,
                         IJobMailListDataTableListRepository jobMailListDataTableListRepository,
                         IJobResponsibleApproversListRepository jobResponsibleApproversListRepository,
                         IJobResponsibleApproversDetailRepository jobResponsibleApproversDetailRepository,
                         IJobErpPhasesFileDetailRepository jobErpPhasesFileDetailRepository,
                         IJobApproverStatusDetailRepository jobApproverStatusDetailRepository,
                         IJobFormListReportExcelRepository jobFormListReportExcelRepository)
        {
            _configuration = configuration;
            _utilityRepository = utilityRepository;
            _jobmasterDetailRepository = jobmasterDetailRepository;
            _jobNotesDetailRepository = jobNotesDetailRepository;
            _jobPhaseDataTableListRepository = jobPhaseDataTableListRepository;
            _jobBudgetDataTableListRepository = jobBudgetDataTableListRepository;
            _jobMailListDataTableListRepository = jobMailListDataTableListRepository;
            _jobResponsibleApproversListRepository = jobResponsibleApproversListRepository;
            _jobResponsibleApproversDetailRepository = jobResponsibleApproversDetailRepository;
            _jobErpPhasesFileDetailRepository = jobErpPhasesFileDetailRepository;
            _jobApproverStatusDetailRepository = jobApproverStatusDetailRepository;
            _jobFormListReportExcelRepository = jobFormListReportExcelRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetDownloadJobFormReportWord(string id)
        {
            try
            {
                string strFileName;
                MemoryStream outputStream = new MemoryStream();

                #region Get data from db

                var result = await _jobmasterDetailRepository.JobmasterDetailMain(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id
                    });

                var notesDetail = await _jobNotesDetailRepository.NotesDetailAsync(
                         BaseSpTcmPLGet(),
                         new ParameterSpTcmPL
                         {
                             PProjno = id
                         });

                var responsibleResult = await _jobResponsibleApproversListRepository.JobResponsibleApproversList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id
                    }
                );

                var erpPhasesResult = await _jobErpPhasesFileDetailRepository.JobErpPhasesFileDetailAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PJobNo = id
                    });

                var phaseResult = await _jobPhaseDataTableListRepository.JobPhaseDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id
                    });

                var approverStatus = await _jobApproverStatusDetailRepository.ApproverStatusDetailAsync(
                                             BaseSpTcmPLGet(),
                                             new ParameterSpTcmPL
                                             {
                                                 PProjno = id
                                             });

                //var budgetResult = await _jobBudgetDataTableListRepository.JobBudgetDataTableList(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PProjno = id,
                //        PRowNumber = 0,
                //        PPageLength = 10000000000
                //    });

                var mailingList = await _jobMailListDataTableListRepository.JobMailListDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PRowNumber = 0,
                        PPageLength = 10000000000
                    });

                #endregion Get data from db

                var templateRepository = _configuration["TCMPLAppTemplatesRepository"];
                var areaRepository = _configuration["AreaRepository:JobForm"];
                var folder = Path.Combine(templateRepository, areaRepository);
                string docPath = Path.Combine(folder, _configuration["AreaRepository:JobFormDocPrint"]); 

                int[,] aryTable1 = new int[,] { { 1, 3 }, { 1, 3 }, { 1, 3 } };
                int[,] aryTable3 = new int[,] { { 1, 3 }, { 1, 3 } };
                int[,] aryTable4 = new int[,] { { 1, 3 }, { 1, 3 }, { 1, 3 }, { 1, 3 }, { 1, 3 } };
                int[,] aryTable5 = new int[,] { { 0, 1 }, { 1, 3 }, { 1, 3 }, { 1, 3 }, { 1, 3 } };
                int[,] aryTable6 = new int[,] { { 1, 3, 5 }, { 1, 3, 5 }, { 0, 0, 0 }, { 0, 0, 0 } };
                int[,] aryTableSignatures = new int[,] { { 0, 1, 2, 3, 4, 5, 6 }, { 0, 1, 2, 3, 4, 5, 6 }, { 0, 1, 2, 3, 4, 5, 6 } };

                byte[] templateBytes = System.IO.File.ReadAllBytes(docPath);

                using (MemoryStream templateStream = new MemoryStream())
                {
                    templateStream.Write(templateBytes, 0, templateBytes.Length);
                    using (WordprocessingDocument doc = WordprocessingDocument.Open(templateStream, true))
                    {
                        //Header

                        #region TableHeader

                        for (int i = 0; i < 2; i++)
                        {
                            HeaderPart firstHeader = doc.MainDocumentPart.HeaderParts.ElementAt(i);
                            Table tableHeader = (Table)firstHeader.Header.ChildElements.First();
                            TableRow tableHeaderRow = tableHeader.Elements<TableRow>().ElementAt(0);
                            TableCell tableHeaderCell = tableHeaderRow.Elements<TableCell>().ElementAt(2);

                            Paragraph tableHeaderParagraph = new();
                            Run rHeader = new();
                            if (i == 0)
                            {
                                tableHeaderParagraph = tableHeaderCell.Elements<Paragraph>().ElementAt(1);
                                rHeader = tableHeaderParagraph.Elements<Run>().ElementAt(1);
                            }
                            else if (i == 1)
                            {
                                tableHeaderParagraph = tableHeaderCell.Elements<Paragraph>().ElementAt(0);
                                rHeader = tableHeaderParagraph.Elements<Run>().ElementAt(1);
                            }
                            Text tHeader = rHeader.Elements<Text>().First();
                            tHeader.Text = id;
                        }

                        #endregion TableHeader

                        //Status - Date

                        #region Table0

                        Table table0 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(0);
                        TableRow table0Row = table0.Elements<TableRow>().ElementAt(0);
                        for (int j = 0; j < 8; j++)
                        {
                            TableCell table0Cell = table0Row.Elements<TableCell>().ElementAt(j);
                            Paragraph table0p = table0Cell.Elements<Paragraph>().First();
                            Run r0 = table0p.Elements<Run>().First();
                            Text t0 = r0.Elements<Text>().First();
                            if (j == 0)
                            {
                                t0.Text = result.PFormMode == "Opening" ? "[ Y ]" : "[  ]";
                            }
                            else if (j == 2)
                            {
                                t0.Text = "[ " + result.PRevision + " ]";
                            }
                            else if (j == 4)
                            {
                                t0.Text = result.PFormMode == "Closing" ? "[ Y ]" : "[  ]";
                            }
                            else if (j == 7)
                            {
                                t0.Text = Convert.ToDateTime(approverStatus.PPmApprlDate).Day.ToString() + "-" + System.Globalization.DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName(Convert.ToDateTime(approverStatus.PPmApprlDate).Month) + "-" + Convert.ToDateTime(approverStatus.PPmApprlDate).Year.ToString();
                            }
                        }

                        #endregion Table0

                        // Job attributes

                        #region Table1

                        Table table1 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(1);
                        for (int i = 1; i <= 2; i++)
                        {
                            TableRow row = table1.Elements<TableRow>().ElementAt(i);
                            for (int j = 0; j < 2; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(aryTable1[i, j]);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 1)
                                {
                                    if (j == 0)
                                        t.Text = result.PCompanyName;
                                    else if (j == 1)
                                        t.Text = result.PIsconsortium == 0 ? "No" : "Yes";
                                }
                                else if (i == 2)
                                {
                                    if (j == 0)
                                        t.Text = result.PJobType + " - " + result.PJobTypeName;
                                    else if (j == 1)
                                        t.Text = result.PTcmno;
                                }

                                if (j == 1)
                                    break;
                            }
                        }

                        #endregion Table1

                        //Project description

                        #region Table2

                        Table table2 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(2);
                        TableRow table2Row = table2.Elements<TableRow>().ElementAt(0);
                        TableCell table2Cell = table2Row.Elements<TableCell>().ElementAt(1);
                        Paragraph table2p = table2Cell.Elements<Paragraph>().First();
                        Run r2 = table2p.Elements<Run>().First();
                        Text t2 = r2.Elements<Text>().First();

                        t2.Text = result.PShortDesc;

                        #endregion Table2

                        //Address

                        #region Table3

                        Table table3 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(3);
                        for (int i = 0; i < 2; i++)
                        {
                            TableRow row = table3.Elements<TableRow>().ElementAt(i);
                            for (int j = 0; j < 2; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(aryTable3[i, j]);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 0)
                                {
                                    if (j == 0)
                                    {
                                        t.Text = result.PPlantProgressNo;
                                    }
                                    else if (j == 1)
                                        t.Text = result.PPlace;
                                }
                                else if (i == 1)
                                {
                                    if (j == 0)
                                        t.Text = result.PCountry;
                                    else if (j == 1)
                                        t.Text = result.PStateName;
                                }

                                if (j == 1)
                                    break;
                            }

                            if (i == 1)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(5);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                t.Text = result.PScopeOfWorkName;
                            }
                        }

                        #endregion Table3

                        //Responsible's

                        #region Table4

                        string EmployeeR01 = null;
                        string EmployeeR02 = null;
                        string EmployeeR03 = null;
                        string EmployeeR04 = null;
                        string EmployeeR05 = null;
                        string EmployeeR06 = null;
                        string EmployeeR07 = null;
                        string EmployeeR08 = null;

                        if (responsibleResult.Count() > 0)
                        {
                            Table table4 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(4);
                            for (int i = 0; i < 5; i++)
                            {
                                TableRow row = table4.Elements<TableRow>().ElementAt(i);
                                for (int j = 0; j < 2; j++)
                                {
                                    TableCell cell = new();
                                    if (i == 1)
                                        cell = row.Elements<TableCell>().ElementAt(3);
                                    else
                                        cell = row.Elements<TableCell>().ElementAt(aryTable4[i, j]);

                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();

                                    #region get names

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R01)
                                        EmployeeR01 = responsibleResult.ElementAt(0).Employee;

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R02)
                                        EmployeeR02 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R02)
                                            EmployeeR02 = responsibleResult.ElementAt(1).Employee;
                                    }

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R03)
                                        EmployeeR03 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R03)
                                            EmployeeR03 = responsibleResult.ElementAt(1).Employee;
                                    }
                                    else if (responsibleResult.Count() > 2)
                                    {
                                        if (responsibleResult.ElementAt(2).JobResponsibleRoleId == R03)
                                            EmployeeR03 = responsibleResult.ElementAt(2).Employee;
                                    }

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R04)
                                        EmployeeR04 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R04)
                                            EmployeeR04 = responsibleResult.ElementAt(1).Employee;
                                    }
                                    else if (responsibleResult.Count() > 2)
                                    {
                                        if (responsibleResult.ElementAt(2).JobResponsibleRoleId == R04)
                                            EmployeeR04 = responsibleResult.ElementAt(2).Employee;
                                    }
                                    else if (responsibleResult.Count() > 3)
                                    {
                                        if (responsibleResult.ElementAt(3).JobResponsibleRoleId == R04)
                                            EmployeeR04 = responsibleResult.ElementAt(3).Employee;
                                    }

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R05)
                                        EmployeeR05 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R05)
                                            EmployeeR05 = responsibleResult.ElementAt(1).Employee;
                                    }
                                    else if (responsibleResult.Count() > 2)
                                    {
                                        if (responsibleResult.ElementAt(2).JobResponsibleRoleId == R05)
                                            EmployeeR05 = responsibleResult.ElementAt(2).Employee;
                                    }
                                    else if (responsibleResult.Count() > 3)
                                    {
                                        if (responsibleResult.ElementAt(3).JobResponsibleRoleId == R05)
                                            EmployeeR05 = responsibleResult.ElementAt(3).Employee;
                                    }
                                    else if (responsibleResult.Count() > 4)
                                    {
                                        if (responsibleResult.ElementAt(4).JobResponsibleRoleId == R05)
                                            EmployeeR05 = responsibleResult.ElementAt(4).Employee;
                                    }

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R06)
                                        EmployeeR06 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R06)
                                            EmployeeR06 = responsibleResult.ElementAt(1).Employee;
                                    }
                                    else if (responsibleResult.Count() > 2)
                                    {
                                        if (responsibleResult.ElementAt(2).JobResponsibleRoleId == R06)
                                            EmployeeR06 = responsibleResult.ElementAt(2).Employee;
                                    }
                                    else if (responsibleResult.Count() > 3)
                                    {
                                        if (responsibleResult.ElementAt(3).JobResponsibleRoleId == R06)
                                            EmployeeR06 = responsibleResult.ElementAt(3).Employee;
                                    }
                                    else if (responsibleResult.Count() > 4)
                                    {
                                        if (responsibleResult.ElementAt(4).JobResponsibleRoleId == R06)
                                            EmployeeR06 = responsibleResult.ElementAt(4).Employee;
                                    }
                                    else if (responsibleResult.Count() > 5)
                                    {
                                        if (responsibleResult.ElementAt(5).JobResponsibleRoleId == R06)
                                            EmployeeR06 = responsibleResult.ElementAt(5).Employee;
                                    }

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R07)
                                        EmployeeR07 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R07)
                                            EmployeeR07 = responsibleResult.ElementAt(1).Employee;
                                    }
                                    else if (responsibleResult.Count() > 2)
                                    {
                                        if (responsibleResult.ElementAt(2).JobResponsibleRoleId == R07)
                                            EmployeeR07 = responsibleResult.ElementAt(2).Employee;
                                    }
                                    else if (responsibleResult.Count() > 3)
                                    {
                                        if (responsibleResult.ElementAt(3).JobResponsibleRoleId == R07)
                                            EmployeeR07 = responsibleResult.ElementAt(3).Employee;
                                    }
                                    else if (responsibleResult.Count() > 4)
                                    {
                                        if (responsibleResult.ElementAt(4).JobResponsibleRoleId == R07)
                                            EmployeeR07 = responsibleResult.ElementAt(4).Employee;
                                    }
                                    else if (responsibleResult.Count() > 5)
                                    {
                                        if (responsibleResult.ElementAt(5).JobResponsibleRoleId == R07)
                                            EmployeeR07 = responsibleResult.ElementAt(5).Employee;
                                    }
                                    else if (responsibleResult.Count() > 6)
                                    {
                                        if (responsibleResult.ElementAt(6).JobResponsibleRoleId == R07)
                                            EmployeeR07 = responsibleResult.ElementAt(6).Employee;
                                    }

                                    if (responsibleResult.ElementAt(0).JobResponsibleRoleId == R08)
                                        EmployeeR08 = responsibleResult.ElementAt(0).Employee;
                                    else if (responsibleResult.Count() > 1)
                                    {
                                        if (responsibleResult.ElementAt(1).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(1).Employee;
                                    }
                                    else if (responsibleResult.Count() > 2)
                                    {
                                        if (responsibleResult.ElementAt(2).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(2).Employee;
                                    }
                                    else if (responsibleResult.Count() > 3)
                                    {
                                        if (responsibleResult.ElementAt(3).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(3).Employee;
                                    }
                                    else if (responsibleResult.Count() > 4)
                                    {
                                        if (responsibleResult.ElementAt(4).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(4).Employee;
                                    }
                                    else if (responsibleResult.Count() > 5)
                                    {
                                        if (responsibleResult.ElementAt(5).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(5).Employee;
                                    }
                                    else if (responsibleResult.Count() > 6)
                                    {
                                        if (responsibleResult.ElementAt(6).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(6).Employee;
                                    }
                                    else if (responsibleResult.Count() > 7)
                                    {
                                        if (responsibleResult.ElementAt(7).JobResponsibleRoleId == R08)
                                            EmployeeR08 = responsibleResult.ElementAt(7).Employee;
                                    }

                                    #endregion get names

                                    if (i == 0)
                                    {
                                        if (j == 0)
                                            t.Text = EmployeeR01;
                                        else if (j == 1)
                                            t.Text = EmployeeR05;
                                    }
                                    if (i == 1)
                                    {
                                        if (j == 1)
                                            t.Text = erpPhasesResult.PMessageType == IsOk ? "Y" : "N";
                                    }
                                    else if (i == 2)
                                    {
                                        if (j == 0)
                                            t.Text = EmployeeR02;
                                        else if (j == 1)
                                            t.Text = EmployeeR06;
                                    }
                                    else if (i == 3)
                                    {
                                        if (j == 0)
                                            t.Text = EmployeeR03;
                                        else if (j == 1)
                                            t.Text = EmployeeR07;
                                    }
                                    else if (i == 4)
                                    {
                                        if (j == 0)
                                            t.Text = EmployeeR04;
                                        else if (j == 1)
                                            t.Text = EmployeeR08;
                                    }
                                }
                            }
                        }

                        #endregion Table4

                        //Client

                        #region Table5

                        Table table5 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(5);
                        for (int i = 0; i <= 3; i++)
                        {
                            TableRow row = table5.Elements<TableRow>().ElementAt(i);
                            for (int j = 0; j < 2; j++)
                            {
                                TableCell cell = row.Elements<TableCell>().ElementAt(aryTable5[i, j]);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 0 & j == 1)
                                {
                                    t.Text = result.PClient;
                                    break;
                                }
                                else if (i == 1)
                                {
                                    if (j == 0)
                                        t.Text = result.PContractNumber;
                                    else if (j == 1)
                                    {
                                        t.Text = result.PContractDate;
                                        break;
                                    }
                                }
                                else if (i == 2)
                                {
                                    if (j == 0)
                                        t.Text = result.PStartDate;
                                    else if (j == 1)
                                    {
                                        t.Text = result.PRevCloseDate;
                                        break;
                                    }
                                }
                                else if (i == 3)
                                {
                                    if (j == 0)
                                        t.Text = result.PExpCloseDate;
                                    else if (j == 1)
                                    {
                                        t.Text = result.PActualCloseDate;
                                        break;
                                    }
                                }
                            }
                        }

                        #endregion Table5

                        //Plant type / Details

                        #region Table6

                        Table table6 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(6);
                        for (int i = 1; i <= 3; i++)
                        {
                            TableRow row = table6.Elements<TableRow>().ElementAt(i);
                            for (int j = 0; j < 3; j++)
                            {
                                TableCell cell = new();

                                if (i == 1)
                                    cell = row.Elements<TableCell>().ElementAt(aryTable6[i, j]);
                                else
                                    cell = row.Elements<TableCell>().ElementAt(1);

                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 1)
                                {
                                    if (j == 0)
                                        t.Text = result.PPlantType == null ? "" : result.PPlantTypeName;
                                    else if (j == 1)
                                        t.Text = result.PBusinessLine == null ? "" : result.PBusinessLineName;
                                    else if (j == 2)
                                        t.Text = result.PSubBusinessLine == null ? "" : result.PSubBusinessLineName;
                                }
                                else if (i == 2)
                                {
                                    if (j == 1)
                                    {
                                        t.Text = notesDetail.PDescription;
                                        break;
                                    }
                                }
                                else if (i == 3)
                                {
                                    if (j == 1)
                                    {
                                        t.Text = notesDetail.PNotes;
                                        break;
                                    }
                                }
                            }
                        }

                        #endregion Table6

                        //AFC

                        #region Table7

                        Table tableSeven = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(7);
                        TableRow tableSevenRow = tableSeven.Elements<TableRow>().ElementAt(0);

                        for (int j = 1; j < 4; j++)
                        {
                            TableCell cell = new();
                            cell = tableSevenRow.Elements<TableCell>().ElementAt(j);
                            Paragraph p = cell.Elements<Paragraph>().First();
                            Run r = p.Elements<Run>().First();
                            Text t = r.Elements<Text>().First();
                            if (j == 1)
                                t.Text = result.PProjectTypeName;
                            else if (j == 3)
                            {
                                t.Text = result.PInvoiceToGrpName;
                                break;
                            }
                        }

                        #endregion Table7

                        //Signatures

                        #region Table signatures

                        Table tableSignatures = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(8);
                        for (int i = 1; i < 3; i++)
                        {
                            TableRow row = tableSignatures.Elements<TableRow>().ElementAt(i);
                            for (int j = 0; j < 7; j++)
                            {
                                TableCell cell = new();
                                cell = row.Elements<TableCell>().ElementAt(aryTableSignatures[i, j]);
                                Paragraph p = cell.Elements<Paragraph>().First();
                                Run r = p.Elements<Run>().First();
                                Text t = r.Elements<Text>().First();
                                if (i == 1)
                                {
                                    if (j == 0)
                                        t.Text = approverStatus.PPmName;
                                    else if (j == 2)
                                        t.Text = approverStatus.PJsApprlDate == null ? "" : approverStatus.PJsName;
                                    else if (j == 4)
                                        t.Text = approverStatus.PMdApprlDate == null ? "" : approverStatus.PMdName;
                                    else if (j == 6)
                                        t.Text = approverStatus.PAfcApprlDate == null ? "" : approverStatus.PAfcName;
                                }
                                else if (i == 2)
                                {
                                    if (j == 0)
                                        t.Text = Convert.ToDateTime(approverStatus.PPmApprlDate).Day.ToString() + "-" + System.Globalization.DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName(Convert.ToDateTime(approverStatus.PPmApprlDate).Month) + "-" + Convert.ToDateTime(approverStatus.PPmApprlDate).Year.ToString();
                                    else if (j == 2)
                                        t.Text = approverStatus.PJsApprlDate == null ? "" : Convert.ToDateTime(approverStatus.PJsApprlDate).Day.ToString() + "-" + System.Globalization.DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName(Convert.ToDateTime(approverStatus.PJsApprlDate).Month) + "-" + Convert.ToDateTime(approverStatus.PJsApprlDate).Year.ToString();
                                    else if (j == 4)
                                        t.Text = approverStatus.PMdApprlDate == null ? "" : Convert.ToDateTime(approverStatus.PMdApprlDate).Day.ToString() + "-" + System.Globalization.DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName(Convert.ToDateTime(approverStatus.PMdApprlDate).Month) + "-" + Convert.ToDateTime(approverStatus.PMdApprlDate).Year.ToString();
                                    else if (j == 6)
                                        t.Text = approverStatus.PAfcApprlDate == null ? "" : Convert.ToDateTime(approverStatus.PAfcApprlDate).Day.ToString() + "-" + System.Globalization.DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName(Convert.ToDateTime(approverStatus.PAfcApprlDate).Month) + "-" + Convert.ToDateTime(approverStatus.PAfcApprlDate).Year.ToString();
                                }
                            }
                        }

                        #endregion Table signatures

                        //Phase

                        #region Table8

                        if (phaseResult.Count() > 0)
                        {
                            Table table8 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(9);
                            for (int i = 1; i <= phaseResult.Count(); i++)
                            {
                                TableRow row = table8.Elements<TableRow>().ElementAt(i);
                                if (phaseResult.Count() > 1)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table8.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 6; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = phaseResult.ElementAt(i - 1).Phase;
                                    else if (j == 1)
                                        t.Text = phaseResult.ElementAt(i - 1).Description;
                                    else if (j == 2)
                                        t.Text = phaseResult.ElementAt(i - 1).Tmagrp;
                                    else if (j == 3)
                                        t.Text = phaseResult.ElementAt(i - 1).Tmagrpdesc;
                                    else if (j == 4)
                                        t.Text = phaseResult.ElementAt(i - 1).BlockBooking == 0 ? "No" : "Yes";
                                    else if (j == 5)
                                        t.Text = phaseResult.ElementAt(i - 1).BlockOt == 0 ? "No" : "Yes";
                                }
                            }
                        }

                        #endregion Table8

                        //Budget

                        #region Table9

                        //if (budgetResult.Count() > 0)
                        //{
                        //    Table table9 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(9);
                        //    for (int i = 1; i <= budgetResult.Count(); i++)
                        //    {
                        //        TableRow row = table9.Elements<TableRow>().ElementAt(i);
                        //        if (budgetResult.Count() > 1)
                        //        {
                        //            if (i > 0)
                        //            {
                        //                TableRow r = (TableRow)row.Clone();
                        //                table9.AppendChild(r);
                        //            }
                        //        }
                        //        for (int j = 0; j < 6; j++)
                        //        {
                        //            TableCell cell = row.Elements<TableCell>().ElementAt(j);
                        //            Paragraph p = cell.Elements<Paragraph>().First();
                        //            Run r = p.Elements<Run>().First();
                        //            Text t = r.Elements<Text>().First();
                        //            if (j == 0)
                        //                t.Text = budgetResult.ElementAt(i - 1).Projno;
                        //            else if (j == 1)
                        //                t.Text = budgetResult.ElementAt(i - 1).Phase;
                        //            else if (j == 2)
                        //                t.Text = budgetResult.ElementAt(i - 1).Yymm;
                        //            else if (j == 3)
                        //                t.Text = budgetResult.ElementAt(i - 1).Costcode;
                        //            else if (j == 4)
                        //                t.Text = budgetResult.ElementAt(i - 1).InitialBudget.ToString();
                        //            else if (j == 5)
                        //                t.Text = budgetResult.ElementAt(i - 1).NewBudget.ToString();
                        //        }
                        //    }
                        //}

                        #endregion Table9

                        //Mailing list

                        #region Table10

                        if (mailingList.Count() > 0)
                        {
                            Table table10 = doc.MainDocumentPart.Document.Body.Elements<Table>().ElementAt(10);
                            for (int i = 1; i <= mailingList.Count(); i++)
                            {
                                TableRow row = table10.Elements<TableRow>().ElementAt(i);
                                if (mailingList.Count() > 1)
                                {
                                    if (i > 0)
                                    {
                                        TableRow r = (TableRow)row.Clone();
                                        table10.AppendChild(r);
                                    }
                                }
                                for (int j = 0; j < 2; j++)
                                {
                                    TableCell cell = row.Elements<TableCell>().ElementAt(j);
                                    Paragraph p = cell.Elements<Paragraph>().First();
                                    Run r = p.Elements<Run>().First();
                                    Text t = r.Elements<Text>().First();
                                    if (j == 0)
                                        t.Text = mailingList.ElementAt(i - 1).CostName;
                                    else if (j == 1)
                                        t.Text = mailingList.ElementAt(i - 1).EmployeeName;
                                }
                            }
                        }

                        #endregion Table10

                        doc.Clone(outputStream);
                    }

                    strFileName = "Job form " + id + ".docx";

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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult DownloadJobFormReportWord(string projno)
        {
            try
            {
                return RedirectToAction("GetDownloadJobFormReportWord", new { id = projno });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> JobFormListReport()
        {
            try
            {
                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "Job_Form_List_Report_" + timeStamp.ToString();

                IEnumerable<JobformListReportExcel> data = await _jobFormListReportExcelRepository.JobFormListReportExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<JobformListReportExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<JobformListReportExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "Job Form List", "Job Form List");

                return File(byteContent,
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                            StrFimeName + ".xlsx");
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }
    }
}