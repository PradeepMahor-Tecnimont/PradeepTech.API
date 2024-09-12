using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpTplVaccineBatchConfiguration  : IEntityTypeConfiguration<SwpTplVaccineBatch>
    {
        public void Configure(EntityTypeBuilder<SwpTplVaccineBatch> entity)
        {
            entity.HasKey(e => e.BatchKeyId)
                .HasName("SWP_TPL_VACINE_BATCH_PK");

            entity.Property(e => e.BatchKeyId).IsUnicode(false);

            entity.Property(e => e.IsOpen).IsUnicode(false);

            entity.Property(e => e.ModifiedBy).IsUnicode(false);

        }
    }
}