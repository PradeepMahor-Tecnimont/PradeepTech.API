using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class DeskAreaCategoriesDataTableListRepository : ViewTcmPLRepository<DeskAreaCategoriesDataTableList>, IDeskAreaCategoriesDataTableListRepository
    {
        public DeskAreaCategoriesDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskAreaCategoriesDataTableList>> DeskAreaCategoriesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_area_categories_qry.fn_area_categories";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<DeskAreaCategoriesDataTableList>> DeskAreaCategoriesDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_area_categories_qry.fn_xl_download_area_categories";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}