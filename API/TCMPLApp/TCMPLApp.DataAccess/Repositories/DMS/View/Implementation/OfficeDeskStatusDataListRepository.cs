using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class OfficeDeskStatusDataListRepository : ViewTcmPLRepository<OfficeDeskStatusXLDataTableList>, IOfficeDeskStatusDataListRepository
    {
        public OfficeDeskStatusDataListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<OfficeDeskStatusXLDataTableList>> OfficeDeskStatusDataListXlAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_reports.fn_office_desk_status";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}