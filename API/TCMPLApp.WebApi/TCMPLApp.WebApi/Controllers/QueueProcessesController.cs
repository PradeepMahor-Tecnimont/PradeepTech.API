using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApi.Classes;
using TCMPLApp.DataAccess.Repositories.WinService;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.WebApi.Models;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class QueueProcessesController : BaseController<QueueProcessesController>
    {
        private readonly IWSQueueProcessesTableListRepository _wsQueueProcessesTableListRepository;
        private readonly IWSQueueProcessesLoggerRepository _wsQueueProcessesLoggerRepository;
        private readonly IWSQueueProcessesUpdateRepository _wsQueueProcessesUpdateRepository;
        public QueueProcessesController(IWSQueueProcessesTableListRepository wsQueueProcessesTableListRepository,
            IWSQueueProcessesLoggerRepository wsQueueProcessesLoggerRepository,
            IWSQueueProcessesUpdateRepository wsQueueProcessesUpdateRepository
            )
        {
            _wsQueueProcessesTableListRepository = wsQueueProcessesTableListRepository;
            _wsQueueProcessesLoggerRepository = wsQueueProcessesLoggerRepository;
            _wsQueueProcessesUpdateRepository = wsQueueProcessesUpdateRepository;
        }

        public class JsonToPost
        {
            public string KeyId { get; set; }
            public string LogMessage { get; set; }
        }

        [Route("GetPendingProcesses")]
        [HttpGet]
        public async Task<ActionResult> GetPendingProcesses()
        {

            var data = await _wsQueueProcessesTableListRepository.GetPendingProcessesListAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL { PRowNumber = 0, PPageLength = 100 }
            );
            return Ok(data);

        }

        [Route("LogInformation")]
        [HttpPost]
        public async Task<ActionResult> LogInformation(JsonToPost jsonData)
        {

            var data = await _wsQueueProcessesLoggerRepository.LogInfoAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PKeyId = jsonData.KeyId,
                    PProcessLog = jsonData.LogMessage
                }
            );
            return Ok(data);
        }

        [Route("LogWarning")]
        [HttpPost]
        public async Task<ActionResult> LogWarning(JsonToPost jsonData)
        {

            var data = await _wsQueueProcessesLoggerRepository.LogWarningAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = jsonData.KeyId,
                    PProcessLog = jsonData.LogMessage
                }
            );
            return Ok(data);
        }

        [Route("LogError")]
        [HttpPost]
        public async Task<ActionResult> LogError(JsonToPost jsonData)
        {

            var data = await _wsQueueProcessesLoggerRepository.LogErrorAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = jsonData.KeyId,
                    PProcessLog = jsonData.LogMessage
                }
            );
            return Ok(data);
        }

        [Route("ProcessStarted")]
        [HttpPost]
        public async Task<ActionResult> ProcessStarted(JsonToPost jsonData)
        {
            var data = await _wsQueueProcessesUpdateRepository.SetStatusStartedAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = jsonData.KeyId,
                    PProcessLog = jsonData.LogMessage
                }
            );
            return Ok(data);
        }

        [Route("StopWithError")]
        [HttpPost]
        public async Task<ActionResult> StopWtihError(JsonToPost jsonData)
        {

            var data = await _wsQueueProcessesUpdateRepository.SetStatusStopWithErrorAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = jsonData.KeyId,
                    PProcessLog = jsonData.LogMessage
                }
            );
            return Ok(data);
        }

        [Route("StopWithSuccess")]
        [HttpPost]
        public async Task<ActionResult> StopWithSuccess(JsonToPost jsonData)
        {

            var data = await _wsQueueProcessesUpdateRepository.SetStatusStopWithSuccessAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = jsonData.KeyId,
                    PProcessLog = jsonData.LogMessage
                }
            );
            return Ok(data);
        }

    }
}
