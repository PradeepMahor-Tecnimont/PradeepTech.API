using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories
{
    public class RSVPViewRepository : ViewTcmPLRepository<NavratriRSVPExcelList>, IRSVPViewRepository
    {
        public RSVPViewRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        #region Navratri RSVP Excel download   

        public async Task<IEnumerable<NavratriRSVPExcelList>> GetNavratriRSVPExcelListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {

            CommandText = "selfservice.iot_rsvp.sp_excel_navratri_rsvp";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        #endregion Navratri RSVP Excel download 
    }
}
