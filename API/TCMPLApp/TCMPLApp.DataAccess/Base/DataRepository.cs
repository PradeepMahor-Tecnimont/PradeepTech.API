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
    public class DataRepository<T> : IDataRepository<T> where T : class
    {
        public DataContext Context { get; set; }

        public DataRepository(DataContext context)
        {
            Context = context;
        }



        public virtual T Get(Expression<Func<T, bool>> predicate)
        {
            return Context.Set<T>()
                .Where<T>(predicate)
                .FirstOrDefault();
        }

        public virtual async Task<T> GetAsync(Expression<Func<T, bool>> predicate)
        {
            return await Context.Set<T>()
                .Where<T>(predicate)
                .FirstOrDefaultAsync();
        }

        public virtual bool AlreadyExists(Expression<Func<T, bool>> predicate)
        {
            return Context.Set<T>()
                .Any<T>(predicate);
        }

        public int GetLast(Expression<Func<T, int>> predicate)
        {
            if (Context.Set<T>().Count() == 0)
                return 0;
            else
                return Context.Set<T>().Max(predicate);
        }

        public async Task<int> GetLastAsync(Expression<Func<T, int>> predicate)
        {

            
            if (await Context.Set<T>().CountAsync() == 0)
                return 0;
            else
                return await Context.Set<T>().MaxAsync(predicate);
        }

        public virtual IEnumerable<T> GetAll()
        {
            return Context.Set<T>()
                .AsNoTracking()
                .ToList();
        }

        public virtual IEnumerable<T> GetAll(Expression<Func<T, bool>> predicate)
        {
            return Context.Set<T>()
                .AsNoTracking()
                .Where<T>(predicate)
                .ToList();
        }

        public virtual async Task<IEnumerable<T>> GetAllAsync()
        {
            return await Context.Set<T>()
                .AsNoTracking()
                .ToListAsync();
        }

        public virtual async Task<IEnumerable<T>> GetAllAsync(Expression<Func<T, bool>> predicate)
        {
            return await Context.Set<T>()
                .AsNoTracking()
                .Where<T>(predicate)
                .ToListAsync();
        }

        public virtual void Insert(T entity)
        {
            if (entity == null)
                throw new ArgumentException("entity is null");

            Context.Set<T>().Add(entity);
            Context.SaveChanges();
        }

        public virtual async Task InsertAsync(T entity)
        {
            if (entity == null)
                throw new ArgumentException("entity is null");

            Context.Set<T>().Add(entity);
            await Context.SaveChangesAsync();
        }

        public virtual void Update(T entity)
        {
            if (entity == null)
                throw new ArgumentException("entity is null");

            Context.Update(entity);
            Context.SaveChanges();
        }

        public virtual async Task UpdateAsync(T entity)
        {
            if (entity == null)
                throw new ArgumentException("entity is null");

            Context.Update(entity);
            await Context.SaveChangesAsync();
        }

        public virtual void Delete(T entity)
        {
            Context.Set<T>().Remove(entity);
            Context.SaveChanges();
        }

        public virtual async Task DeleteAsync(T entity)
        {
            Context.Set<T>().Remove(entity);
            await Context.SaveChangesAsync();
        }

        public void Dispose()
        {
            Context.Dispose();
            GC.SuppressFinalize(this);
        }

    }
}


