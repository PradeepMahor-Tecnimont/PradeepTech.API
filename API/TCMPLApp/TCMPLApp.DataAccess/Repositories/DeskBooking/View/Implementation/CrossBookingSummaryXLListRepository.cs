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
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class CrossBookingSummaryXLListRepository : ViewTcmPLRepository<CrossBookingSummaryDataTableListXL>, ICrossBookingSummaryXLListRepository
    {
        public CrossBookingSummaryXLListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<CrossBookingSummaryDataTableListXL>> CrossBookingSummaryXLForDmsListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_summary_qry.fn_summary_cross_office_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<CrossBookingSummaryDataTableListXL>> CrossBookingSummaryXLForHodListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_summary_qry.fn_hod_summary_cross_office_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}