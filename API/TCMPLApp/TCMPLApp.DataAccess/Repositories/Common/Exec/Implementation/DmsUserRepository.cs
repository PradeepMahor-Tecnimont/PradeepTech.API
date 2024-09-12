using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;

using System.Dynamic;

namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class DmsUserRepository : ExecRepository, IDmsUser
    {

        public DmsUserRepository(ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<DmsUserCheck> CheckUserAccess(DmsUserCheck dmsUserCheck)
        {
            return await ExecuteProcAsync(dmsUserCheck);
        }


    }
}
