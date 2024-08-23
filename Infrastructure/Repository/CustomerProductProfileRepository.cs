using Core.Entities;
using Core.Interfaces;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repository
{
    public class CustomerProductProfileRepository(StoreContext context) : ICustomerProductProfileRepository
    {
        public void AddCustomerProductProfileAsync(CustomerProductProfile CustomerProductProfile)
        {
            context.CustomerProductProfiles.Add(CustomerProductProfile);
        }

        public void DeleteCustomerProductProfileAsync(CustomerProductProfile CustomerProductProfile)
        {
            context.CustomerProductProfiles.Remove(CustomerProductProfile);
        }

        public async Task<CustomerProductProfile?> GetCustomerProductProfileByIdAsync(int id)
        {
            return await context.CustomerProductProfiles.FindAsync(id);
        }

        public async Task<IReadOnlyList<CustomerProductProfile>> GetCustomerProductProfilesAsync()
        {
            return await context.CustomerProductProfiles.ToListAsync();
        }

        public bool CustomerProductProfileExists(int id)
        {
            return context.CustomerProductProfiles.Any(p => p.Id == id);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }

        public void UpdateCustomerProductProfileAsync(CustomerProductProfile CustomerProductProfile)
        {
            context.Entry(CustomerProductProfile).State = EntityState.Modified;
        }
    }
}