using ClosedXML.Report;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.RapReporting;
using TCMPLApp.WebApi.Classes;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class RapReportingProcessesController : BaseController<RapReportingProcessesController>
    {
        
        private readonly ICostcodeGroupCostcodeDataTableListRepository _costcodeGroupCostcodeDataTableListRepository;
        public RapReportingProcessesController(ICostcodeGroupCostcodeDataTableListRepository costcodeGroupCostcodeDataTableListRepository)
        {
            _costcodeGroupCostcodeDataTableListRepository = costcodeGroupCostcodeDataTableListRepository;
        }

        [Route("GetCostcodeGroupCostcodeList")]
        [HttpGet]
        public async Task<ActionResult> GetCostcodeGroupCostcodeList(string costCodeGroupId)
        {
            var data = await _costcodeGroupCostcodeDataTableListRepository.CostcodeGroupCostcodeList(
                 BaseSpTcmPLGet(),
                 new ParameterSpTcmPL { PCostcodeGroupId = costCodeGroupId }
                );

            if (!data.Any())
                return StatusCode((int)HttpStatusCode.InternalServerError, "No data found");

            return Ok(data);
        }
    }
}
