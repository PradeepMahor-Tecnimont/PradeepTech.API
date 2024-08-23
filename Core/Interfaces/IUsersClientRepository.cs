using Core.Entities;

namespace Core.Interfaces
{
    public interface IUsersClientRepository
    {
        Task<IReadOnlyList<UsersClient>> GetUsersClientsAsync();

        Task<UsersClient?> GetUsersClientByIdAsync(int id);

        void AddUsersClientAsync(UsersClient UsersClient);

        void UpdateUsersClientAsync(UsersClient UsersClient);

        void DeleteUsersClientAsync(UsersClient UsersClient);

        bool UsersClientExists(int id);

        Task<bool> SaveChangesAsync();
    }
}