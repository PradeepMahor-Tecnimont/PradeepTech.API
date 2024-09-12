using ClosedXML.Excel;
using ClosedXML.Report;
using DocumentFormat.OpenXml.EMMA;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Models;
using RapReportingApi.Models.rpt.Cmplx;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace RapReportingApi.Controllers.Rpt.Cmplx.proco
{
    [Authorize]
    public class TM01AllController : ControllerBase
    {
        private ITM01AllRepository tm01allRepository;
        private RAPDbContext _dbContext;
        private IOptions<AppSettings> appSettings;

        public TM01AllController(ITM01AllRepository _tm01allRepository, RAPDbContext paramDBContext, IOptions<AppSettings> _appSettings)
        {
            tm01allRepository = _tm01allRepository;
            _dbContext = paramDBContext;
            appSettings = _appSettings;
        }

        [HttpGet]
        [Route("api/rap/rpt/cmplx/proco/GetTM01All")]
        public async Task<ActionResult> GetTM01All(string yymm, string simul, string yearmode)
        {
            string inputFile = Common.CustomFunctions.GetRAPRepository(appSettings.Value) +
                               "\\Cmplx\\proco\\TM01All.xlsm";

            DataSet dsProjList = new DataSet();
            DataSet dsProj = new DataSet();
            DataSet dsData = new DataSet();

            List<tm01allmodel> tm01Data = new List<tm01allmodel>();            
            List<tm01allmodel> tm01Data_Mumbai = new List<tm01allmodel>();            
            List<tm01allmodel> tm01Data_Delhi = new List<tm01allmodel>();            

            var sheetName = "";
            var reportMode = "";
            var deptCode = "";

            try
            {
                byte[] m_Bytes = null;

                using (var tmlt = new XLTemplate(inputFile))
                {
                    var wb = tmlt.Workbook;                                        

                    for (int i = 0; i < 3; i++)
                    {
                        if (i == 0)
                        {
                            sheetName = "Combined M + D";
                            reportMode = "COMBINED";
                            deptCode = "";
                        }
                        else if (i == 1)
                        {
                            sheetName = "Mumbai";
                            reportMode = "SINGLE";
                            deptCode = "";
                        }
                        else if (i == 2)
                        {
                            sheetName = "Delhi";
                            reportMode = "SINGLE";
                            deptCode = "D";
                        }

                        var ws = wb.Worksheet(sheetName);

                        dsProjList = (DataSet)tm01allRepository.GetProjectList(yymm, simul, reportMode, deptCode);

                        Int32 printHeader = 0;

                        ws.Cell(2, 56).Value = "'" + DateTime.Now.ToString("dd-MMM-yyyy");
                        ws.Cell(3, 56).Value = "'" + yymm.Substring(0, 4) + "/" + yymm.Substring(4, 2);

                        foreach (DataRow pp in dsProjList.Tables["projListTable"].Rows)
                        {
                            dsProj = (DataSet)tm01allRepository.GetProjectData(pp["Projno"].ToString());
                            dsData = (DataSet)tm01allRepository.GetTM011AllData(Request.Headers["activeYear"].ToString(), yymm, simul, yearmode, pp["Projno"].ToString(), reportMode, deptCode);

                            if (printHeader == 0)
                            {
                                foreach (DataColumn cc in dsData.Tables["colsTable"].Columns)
                                {
                                    Int32 col = dsData.Tables["colsTable"].Columns.IndexOf(cc);
                                    string strVal = dsData.Tables["colsTable"].Rows[0][cc.ColumnName.ToString()].ToString();
                                    ws.Cell(8, col + 8).Value = "'" + strVal.Substring(0, 4) + "/" + strVal.Substring(4, 2);
                                    ws.Cell(8, col + 8).DataType = XLDataType.Text;
                                }
                                printHeader = 1;
                            }

                            Int32 ddrow = dsProjList.Tables["projListTable"].Rows.IndexOf(pp);

                            foreach (DataRow pd in dsProj.Tables["projTable"].Rows)
                            {
                                try
                                {
                                    tm01allmodel dataResult = new tm01allmodel();
                                    List<CostDetails> costList = new List<CostDetails>();
                                    foreach (DataRow dd in dsData.Tables["dataTable"].Rows)
                                    {
                                        try
                                        {
                                            CostDetails costResult = new CostDetails();
                                            costResult.Costcode = dd["costcode"].ToString();
                                            costResult.Name = dd["name"].ToString();
                                            costResult.Revised = (dd["revised"] == DBNull.Value) ? 0 : Convert.ToDouble(dd["revised"].ToString());
                                            costResult.Curryear = Convert.ToDouble(dd["curryear"].ToString());
                                            costResult.Opening = (dd["opening"] == DBNull.Value) ? 0 : Convert.ToDouble(dd["opening"].ToString());
                                            costResult.A = (dd[6] == DBNull.Value) ? 0 : Convert.ToDouble(dd[6].ToString());
                                            costResult.B = (dd[7] == DBNull.Value) ? 0 : Convert.ToDouble(dd[7].ToString());
                                            costResult.C = (dd[8] == DBNull.Value) ? 0 : Convert.ToDouble(dd[8].ToString());
                                            costResult.D = (dd[9] == DBNull.Value) ? 0 : Convert.ToDouble(dd[9].ToString());
                                            costResult.E = (dd[10] == DBNull.Value) ? 0 : Convert.ToDouble(dd[10].ToString());
                                            costResult.F = (dd[11] == DBNull.Value) ? 0 : Convert.ToDouble(dd[11].ToString());
                                            costResult.G = (dd[12] == DBNull.Value) ? 0 : Convert.ToDouble(dd[12].ToString());
                                            costResult.H = (dd[13] == DBNull.Value) ? 0 : Convert.ToDouble(dd[13].ToString());
                                            costResult.I = (dd[14] == DBNull.Value) ? 0 : Convert.ToDouble(dd[14].ToString());
                                            costResult.J = (dd[15] == DBNull.Value) ? 0 : Convert.ToDouble(dd[15].ToString());
                                            costResult.K = (dd[16] == DBNull.Value) ? 0 : Convert.ToDouble(dd[16].ToString());
                                            costResult.L = (dd[17] == DBNull.Value) ? 0 : Convert.ToDouble(dd[17].ToString());
                                            costResult.M = (dd[18] == DBNull.Value) ? 0 : Convert.ToDouble(dd[18].ToString());
                                            costResult.N = (dd[19] == DBNull.Value) ? 0 : Convert.ToDouble(dd[19].ToString());
                                            costResult.O = (dd[20] == DBNull.Value) ? 0 : Convert.ToDouble(dd[20].ToString());
                                            costResult.P = (dd[21] == DBNull.Value) ? 0 : Convert.ToDouble(dd[21].ToString());
                                            costResult.Q = (dd[22] == DBNull.Value) ? 0 : Convert.ToDouble(dd[22].ToString());
                                            costResult.R = (dd[23] == DBNull.Value) ? 0 : Convert.ToDouble(dd[23].ToString());
                                            costResult.S = (dd[24] == DBNull.Value) ? 0 : Convert.ToDouble(dd[24].ToString());
                                            costResult.T = (dd[25] == DBNull.Value) ? 0 : Convert.ToDouble(dd[25].ToString());
                                            costResult.U = (dd[26] == DBNull.Value) ? 0 : Convert.ToDouble(dd[26].ToString());
                                            costResult.V = (dd[27] == DBNull.Value) ? 0 : Convert.ToDouble(dd[27].ToString());
                                            costResult.W = (dd[28] == DBNull.Value) ? 0 : Convert.ToDouble(dd[28].ToString());
                                            costResult.X = (dd[29] == DBNull.Value) ? 0 : Convert.ToDouble(dd[29].ToString());
                                            costResult.Y = (dd[30] == DBNull.Value) ? 0 : Convert.ToDouble(dd[30].ToString());
                                            costResult.Z = (dd[31] == DBNull.Value) ? 0 : Convert.ToDouble(dd[31].ToString());
                                            costResult.AA = (dd[32] == DBNull.Value) ? 0 : Convert.ToDouble(dd[32].ToString());
                                            costResult.AB = (dd[33] == DBNull.Value) ? 0 : Convert.ToDouble(dd[33].ToString());
                                            costResult.AC = (dd[34] == DBNull.Value) ? 0 : Convert.ToDouble(dd[34].ToString());
                                            costResult.AD = (dd[35] == DBNull.Value) ? 0 : Convert.ToDouble(dd[35].ToString());
                                            costResult.AE = (dd[36] == DBNull.Value) ? 0 : Convert.ToDouble(dd[36].ToString());
                                            costResult.AF = (dd[37] == DBNull.Value) ? 0 : Convert.ToDouble(dd[37].ToString());
                                            costResult.AG = (dd[38] == DBNull.Value) ? 0 : Convert.ToDouble(dd[38].ToString());
                                            costResult.AH = (dd[39] == DBNull.Value) ? 0 : Convert.ToDouble(dd[39].ToString());
                                            costResult.AI = (dd[40] == DBNull.Value) ? 0 : Convert.ToDouble(dd[40].ToString());
                                            costResult.AJ = (dd[41] == DBNull.Value) ? 0 : Convert.ToDouble(dd[41].ToString());
                                            costResult.AK = (dd[42] == DBNull.Value) ? 0 : Convert.ToDouble(dd[42].ToString());
                                            costResult.AL = (dd[43] == DBNull.Value) ? 0 : Convert.ToDouble(dd[43].ToString());
                                            costResult.AM = (dd[44] == DBNull.Value) ? 0 : Convert.ToDouble(dd[44].ToString());
                                            costResult.AN = (dd[45] == DBNull.Value) ? 0 : Convert.ToDouble(dd[45].ToString());
                                            costResult.AO = (dd[46] == DBNull.Value) ? 0 : Convert.ToDouble(dd[46].ToString());
                                            costResult.AP = (dd[47] == DBNull.Value) ? 0 : Convert.ToDouble(dd[47].ToString());
                                            costResult.AQ = (dd[48] == DBNull.Value) ? 0 : Convert.ToDouble(dd[48].ToString());
                                            costResult.AR = (dd[49] == DBNull.Value) ? 0 : Convert.ToDouble(dd[49].ToString());
                                            costResult.AS = (dd[50] == DBNull.Value) ? 0 : Convert.ToDouble(dd[50].ToString());
                                            costResult.AT = (dd[51] == DBNull.Value) ? 0 : Convert.ToDouble(dd[51].ToString());
                                            costResult.AU = (dd[52] == DBNull.Value) ? 0 : Convert.ToDouble(dd[52].ToString());
                                            costResult.AV = (dd[53] == DBNull.Value) ? 0 : Convert.ToDouble(dd[53].ToString());

                                            costList.Add(costResult);
                                        }
                                        catch (Exception)
                                        {
                                            throw;
                                        }
                                    }

                                    dataResult.Projno = pd["projno"].ToString();
                                    dataResult.Tcmno = pd["tcmno"].ToString().Trim();
                                    dataResult.Name = pd["name"].ToString().Trim();
                                    dataResult.Sdate = pd["sdate"].ToString().Trim();
                                    dataResult.Edate = pd["edate"].ToString().Trim();
                                    dataResult.Mnths = Convert.ToDouble("0" + pd["Mnths"].ToString().Trim());
                                    dataResult.Details = costList.ToList();

                                    if (i == 0)
                                        tm01Data.Add(dataResult);
                                    else if (i == 1)
                                        tm01Data_Mumbai.Add(dataResult);
                                    else if (i == 2)
                                        tm01Data_Delhi.Add(dataResult);
                                }
                                catch (Exception)
                                {
                                    throw;
                                }
                            }
                        }
                        if (i == 0)                                                    
                            tmlt.AddVariable("tm01allmodel", tm01Data);                        
                        else if (i == 1)
                            tmlt.AddVariable("tm01allmodel_Mumbai", tm01Data_Mumbai);
                        else if (i == 2)
                            tmlt.AddVariable("tm01allmodel_Delhi", tm01Data_Delhi);
                    } 

                    tmlt.Generate();

                    using (MemoryStream ms = new MemoryStream())
                    {
                        wb.SaveAs(ms);
                        byte[] buffer = ms.GetBuffer();
                        long length = ms.Length;
                        m_Bytes = ms.ToArray();
                    }

                    string strFileName = string.Empty;
                    strFileName = "TM01All" + yymm.Trim().Substring(2, 4).ToString() + ".xlsm";

                    var t = Task.Run(() =>
                    {
                        return this.File(fileContents: m_Bytes,
                                            contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
                                            fileDownloadName: strFileName
                                        );
                    });
                    Response.Headers.Add("xl_file_name", strFileName);
                    return await t;
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                dsProj.Dispose();
                dsData.Dispose();
            }
        }
    }
}