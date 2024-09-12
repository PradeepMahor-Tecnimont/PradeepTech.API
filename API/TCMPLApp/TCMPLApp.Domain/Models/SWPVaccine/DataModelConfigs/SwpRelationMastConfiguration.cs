using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpRelationMastConfiguration : IEntityTypeConfiguration<SwpRelationMast>
    {
        public void Configure(EntityTypeBuilder<SwpRelationMast> entity)
        {
            entity.HasKey(e => e.RelationCode)
                .HasName("SWP_RELATION_MAST_PK");

            entity.Property(e => e.RelationCode).IsUnicode(false);

            entity.Property(e => e.RelationDesc).IsUnicode(false);
        }
    }
}