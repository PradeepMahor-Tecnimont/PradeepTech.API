using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class ICardConsentXLDataTableListRepository : ViewTcmPLRepository<ICardConsentStatusXlDataTableList>, IICardConsentXLDataTableListRepository
    {
        public ICardConsentXLDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<ICardConsentStatusXlDataTableList>> ICardConsentStatusXLDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_icard_photo_consent_qry.sp_icard_photo_consent_xl_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
