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
    public class DeskAreaUserMapHodDataTableListRepository : ViewTcmPLRepository<DeskAreaUserMapHodDataTableList>, IDeskAreaUserMapHodDataTableListRepository
    {
        public DeskAreaUserMapHodDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<DeskAreaUserMapHodDataTableList>> DeskAreaUserMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_User_mapping_hod_qry.fn_dm_area_type_User_mapping_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<DeskAreaUserMapHodDataTableList>> DeskAreaUserMapDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_area_type_User_mapping_hod_qry.fn_dm_area_type_User_mapping_xl_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}