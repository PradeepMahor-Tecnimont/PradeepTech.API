using Core.Entities;
using Core.Interfaces;
using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repository
{
    public class UsersClientRepository(StoreContext context) : IUsersClientRepository
    {
        public void AddUsersClientAsync(UsersClient UsersClient)
        {
            context.UsersClients.Add(UsersClient);
        }

        public void DeleteUsersClientAsync(UsersClient UsersClient)
        {
            context.UsersClients.Remove(UsersClient);
        }

        public async Task<UsersClient?> GetUsersClientByIdAsync(int id)
        {
            return await context.UsersClients.FindAsync(id);
        }

        public async Task<IReadOnlyList<UsersClient>> GetUsersClientsAsync()
        {
            return await context.UsersClients.ToListAsync();
        }

        public bool UsersClientExists(int id)
        {
            return context.UsersClients.Any(p => p.Id == id);
        }

        public async Task<bool> SaveChangesAsync()
        {
            return await context.SaveChangesAsync() > 0;
        }

        public void UpdateUsersClientAsync(UsersClient UsersClient)
        {
            context.Entry(UsersClient).State = EntityState.Modified;
        }
    }
}