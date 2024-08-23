using Core.Entities;
using Core.Interfaces;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repository
{
    public class UserCustomerRepository(StoreContext context) : IUserCustomerRepository
    {
        public void AddUserCustomerAsync(UserCustomer UserCustomer)
        {
            context.UserCustomers.Add(UserCustomer);
        }

        public void DeleteUserCustomerAsync(UserCustomer UserCustomer)
        {
            context.UserCustomers.Remove(UserCustomer);
        }

        public async Task<UserCustomer?> GetUserCustomerByIdAsync(int id)
        {
            return await context.UserCustomers.FindAsync(id);
        }

        public async Task<IReadOnlyList<UserCustomer>> GetUserCustomersAsync()
        {
            return await context.UserCustomers.ToListAsync();
        }

        public bool UserCustomerExists(int id)
        {
            return context.UserCustomers.Any(p => p.Id == id);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }

        public void UpdateUserCustomerAsync(UserCustomer UserCustomer)
        {
            context.Entry(UserCustomer).State = EntityState.Modified;
        }
    }
}