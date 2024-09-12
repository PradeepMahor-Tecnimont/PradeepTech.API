using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpBusRouteConfiguration : IEntityTypeConfiguration<SwpBusRoute>
    {
        public void Configure(EntityTypeBuilder<SwpBusRoute> entity)
        {
            entity.HasKey(e => e.RouteId)
                .HasName("SWP_BUS_ROUTES_PK");

            entity.Property(e => e.RouteId).IsUnicode(false);

            entity.Property(e => e.PickupPoints).IsUnicode(false);

        }
    }
}