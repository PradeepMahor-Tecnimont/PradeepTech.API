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
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class LoAAddendumConsentUpdateRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, ILoAAddendumConsentUpdateRepository
    {
        public LoAAddendumConsentUpdateRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> LoAAddendumConsentUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_loa_addendum_acceptance.sp_update_emp_loa_addendum_acceptance";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }


        public async Task<DBProcMessageOutput> PDFGeneratedEventUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_loa_addendum_acceptance.sp_add_event_pdf_generated";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> EmailQueuedEventUpdateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_loa_addendum_acceptance.sp_add_event_email_queued";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }


    }



}
