using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
//using TCMPLApp.BaseRoleProvider;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Context;
using Dapper;
using Microsoft.EntityFrameworkCore;
using TCMPLApp.Domain.Models;
using System.Data;

namespace TCMPLApp.WebApp
{
    //public class RoleProvider : IBaseRoleProvider
    //{
    //    public const string ADMIN = "ADMIN";
    //    public const string BASIC_USER = "SWP_USER";
    //    public const string HOD_USER = "SWP_HOD";
    //    public const string HR_APPROVER = "SWP_HR";
    //    public const string GENSE_ADMIN = "SWP_GENSE";
    //    public const string TESTING_USER = "TESTING_USER";

    //    private readonly IServiceScopeFactory _scopeFactory;

    //    public RoleProvider(IServiceScopeFactory scopeFactory)
    //    {
    //        _scopeFactory = scopeFactory;

    //    }
    //    public async Task<ICollection<string>> GetUserRolesAsync(string userName)
    //    {
    //        ICollection<string> result = new string[0];

    //        using (var scope = _scopeFactory.CreateScope())
    //        {
    //            var db = scope.ServiceProvider.GetRequiredService<ExecDBContext>();

    //            var inParams = new { param_win_uid = userName };
    //            var outParams = new { param_roles = "" };
    //            var conn = db.Database.GetDbConnection();
    //            var retVal = await ExecuteProc(conn, "selfservice.swp_users.get_roles_for_user", inParams, outParams);
    //            var recievedVals = (Dictionary<string, string>)retVal.Data;

    //            result = recievedVals["param_roles"].Split(",");
    //        }


    //        return await Task.FromResult(result);
    //    }

    //    private async Task<ProcedureResult> ExecuteProc(System.Data.Common.DbConnection db, string sql, object paramList = null, object paramListOut = null)
    //    {
    //        try
    //        {
    //            DynamicParameters dynamicParameters = null;
    //            if (paramList != null)
    //                dynamicParameters = new DynamicParameters(paramList);
    //            else
    //                dynamicParameters = new DynamicParameters();

    //            if (paramListOut != null)
    //            {
    //                var popList = paramListOut.GetType().GetProperties();
    //                foreach (var prop in popList)
    //                {
    //                    dynamicParameters.Add(prop.Name, null, DbType.String, ParameterDirection.Output, 1000);
    //                }
    //            }
    //            dynamicParameters.Add(name: "Param_Success", "", dbType: DbType.String, direction: ParameterDirection.Output, size: 10);
    //            dynamicParameters.Add(name: "Param_Message", "", dbType: DbType.String, direction: ParameterDirection.Output, size: 1000);

    //            await db.ExecuteAsync(sql, dynamicParameters, commandType: CommandType.StoredProcedure);

    //            var retVal = new ProcedureResult { Status = dynamicParameters.Get<string>("Param_Success"), Message = dynamicParameters.Get<string>("Param_Message") };
    //            if (!(paramListOut == null))
    //            {
    //                var popList = paramListOut.GetType().GetProperties();
    //                Dictionary<string, string> outParams = new Dictionary<string, string>();
    //                foreach (var prop in popList)
    //                {
    //                    var value = dynamicParameters.Get<dynamic>(prop.Name);
    //                    outParams.Add(prop.Name, value);
    //                }
    //                retVal.Data = outParams;
    //            }
    //            return retVal;
    //        }
    //        catch (Exception e)
    //        {
    //            //do logging
    //            return new ProcedureResult { Message = e.Message, Status = "KO" };
    //        }
    //    }

    //}
}
