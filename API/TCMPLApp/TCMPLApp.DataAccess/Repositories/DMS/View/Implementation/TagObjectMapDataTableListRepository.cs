using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DeskBooking;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class TagObjectMapDataTableListRepository : ViewTcmPLRepository<TagObjectMapDataTableList>, ITagObjectMapDataTableListRepository
    {
        public TagObjectMapDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<TagObjectMapDataTableList>> TagObjectMapDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_tag_obj_mapping_qry.fn_tag_obj_mapping_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<TagObjectMapDataTableList>> TagObjectMapDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_tag_obj_mapping_qry.sp_tag_obj_mapping_xl_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
