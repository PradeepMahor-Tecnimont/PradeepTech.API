using TCMPLApp.Domain.Context;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;

namespace TCMPLApp.DataAccess.Base
{
    public interface IDataRepository<T> : IDisposable
    {
        DataContext Context { get; set; }

        T Get(Expression<Func<T, bool>> predicate);

        Task<T> GetAsync(Expression<Func<T, bool>> predicate);

        bool AlreadyExists(Expression<Func<T, bool>> predicate);

        int GetLast(Expression<Func<T, int>> predicate);

        Task<int> GetLastAsync(Expression<Func<T, int>> predicate);

        IEnumerable<T> GetAll();

        IEnumerable<T> GetAll(Expression<Func<T, bool>> predicate);

        Task<IEnumerable<T>> GetAllAsync();

        Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>> predicate);

        void Insert(T entity);

        Task InsertAsync(T entity);

        void Update(T entity);

        Task UpdateAsync(T entity);

        void Delete(T entity);

        Task DeleteAsync(T entity);
    }
}
