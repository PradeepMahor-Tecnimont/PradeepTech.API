using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;


namespace TCMPLApp.DataAccess.Base
{
    public interface IExecRepository : IDisposable
    {
        //public Task<Models.ProcedureResult> ExecuteProc(string sql, object paramList = null);

        public Task<Domain.Models.ProcedureResult> ExecuteProc(string sql, object paramList = null, object paramListOut = null);

        public Task<T> QueryFirstOrDefaultAsync<T>(string query, object parameters = null);

        public Task<IEnumerable<T>> QueryAsync<T>(string query, object parameters = null);

        public IEnumerable<T> Query<T>(string query, object parameters = null);


        public Task<T> ExecuteProcAsync<T>(T t);

        public T ExecuteProc<T>(T t);

    }
}
