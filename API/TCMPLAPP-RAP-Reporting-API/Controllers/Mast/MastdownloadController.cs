

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using RapReportingApi.Models;
using RapReportingApi.Repositories.Interfaces.Mast;
using System.Threading.Tasks;


namespace RapReportingApi.Controllers.Mast
{
    [Authorize]
    [Route("api/rap/[controller]")]
    public class MastdownloadController : ControllerBase
    {
        private IOptions<AppSettings> appSettings;
        private IMastdownloadRepository mastdownloadRepository;

        public MastdownloadController(IMastdownloadRepository _mastdownloadRepository, IOptions<AppSettings> _settings)
        {
            mastdownloadRepository = _mastdownloadRepository;
            appSettings = _settings;
        }

        //[HttpGet]
        //[EnableQuery()]
        //[Route("getDownLoadClient")]
        //public async Task<ActionResult> getDownLoadClient()
        //{
        //    string strFileName = string.Empty;
        //    strFileName = "ClientMaster.xlsx";
        //    var t = Task.Run(() =>
        //    {
        //        byte[] m_Bytes = mastdownloadRepository.getDownLoadClient();
        //        return this.File(
        //                       fileContents: m_Bytes,
        //                       contentType: appSettings.Value.RAPAppSettings.ClosedXMLContentType.ToString(),
        //                       fileDownloadName: strFileName
        //                   );
        //    });
        //    Response.Headers.Add("xl_file_name", strFileName);
        //    return await t;
        //}

    }
}