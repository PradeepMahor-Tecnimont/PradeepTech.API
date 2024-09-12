using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;

using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HSE;

namespace TCMPLApp.DataAccess.Repositories.HSE
{
    public class HSESuggestionDataTableListRepository : ViewTcmPLRepository<HSESuggestionDataTableList>, IHSESuggestionDataTableListRepository
    {
        public HSESuggestionDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HSESuggestionDataTableList>> HSESuggestionDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_hse_qry.fn_hse_suggestion";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}