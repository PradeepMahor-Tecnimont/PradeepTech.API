using MailKit.Net.Smtp;
using MimeKit;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
//using System.Net.Mail;
using TCMPLAPP.SendMail.WinService.Models;
using TCMPLAPP.SendMail.WinService.Repository;


namespace TCMPLAPP.SendMail.WinService
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly IServiceProvider _serviceProvider;
        private readonly IServiceScopeFactory _serviceScopeFactory;
        private readonly IMailQueueMailsTableListRepository _mailQueueMailsTableListRepository;
        private readonly IMailQueueMailsRepository _mailQueueMailsRepository;
        private readonly IConfiguration _configuration;
        private readonly double _workerProcessDelayInMinutes;
        private readonly string _applicationErrorFilePathName;
        public Worker(ILogger<Worker> logger, IConfiguration configuration,
            IServiceProvider serviceProvider,
            IServiceScopeFactory serviceScopeFactory,
            IMailQueueMailsTableListRepository mailQueueMailsTableListRepository,
            IMailQueueMailsRepository mailQueueMailsRepository
            )
        {
            _logger = logger;
            _serviceProvider = serviceProvider;
            _serviceScopeFactory = serviceScopeFactory;
            _configuration = configuration;
            _mailQueueMailsTableListRepository = mailQueueMailsTableListRepository;
            _mailQueueMailsRepository = mailQueueMailsRepository;
            string? delay = _configuration.GetSection("WorkerProcessDelayInMinutes").Value?.ToString();
            _workerProcessDelayInMinutes = double.Parse(delay ?? "10");
            _applicationErrorFilePathName = AppDomain.CurrentDomain.BaseDirectory + "Error.txt";
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);

                DoWorkAsync().Wait(stoppingToken);


                await Task.Delay(TimeSpan.FromMinutes(_workerProcessDelayInMinutes), stoppingToken);
            }
        }

        public override Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now}: Mail worker started.");

            return base.StartAsync(cancellationToken);
        }


        public override Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now}: Mail worker stopped.");

            return base.StopAsync(cancellationToken);
        }

        private async Task DoWorkAsync()
        {
            SmtpClient emailClient = new();
            try
            {


                //await SendAllAsync();
                bool checkCheckForPendingMails = true;
                string smtpServer = _configuration.GetSection("SMTPServer").Value?.ToString();
                int smtpPort = int.Parse(_configuration.GetSection("SMTPServerPort").Value?.ToString() ?? "587");


                double smtpMailDelayInSeconds = double.Parse(_configuration.GetSection("SMTPMailDelayInSeconds").Value?.ToString() ?? "2.5");

                string smtpMailLoginId = _configuration.GetSection("SMTPMailId").Value?.ToString();
                string smtpLoginPwd = _configuration.GetSection("SMTPUserPwd").Value?.ToString();

                string smtpMailfromMailId = smtpMailLoginId;

                string attachmentsRepository = _configuration.GetSection("TCMPLAppMailAttachmentPickUpRepository").Value?.ToString();

                var pendingMails = await _mailQueueMailsTableListRepository.GetPendingMailsListAsync(new Models.BaseSpTcmPL(), new ParameterSpTcmPL { PRowNumber = 0, PPageLength = 100 });
                _logger.LogInformation("Pending Mails fetched - " + pendingMails?.Count());
                var mails = pendingMails ?? Enumerable.Empty<MailQueueModel>();

                if (!mails.Any())
                {
                    checkCheckForPendingMails = false;
                }

                if (checkCheckForPendingMails)
                {
                    _logger.LogInformation("validation callback start");
                    emailClient.ServerCertificateValidationCallback = (s, c, h, e) => true;
                    _logger.LogInformation("validation callback end");

                    _logger.LogInformation("Trying Remove XOAUTH2");
                    emailClient.AuthenticationMechanisms.Remove("XOAUTH2");
                    _logger.LogInformation("Removed XOAUTH2");


                    _logger.LogInformation("Trying to connect to smtp.office365.com");
                    emailClient.Connect(smtpServer, smtpPort, MailKit.Security.SecureSocketOptions.StartTls);
                    _logger.LogInformation("Connect complete");

                    _logger.LogInformation("Trying to authenticate");
                    emailClient.Authenticate(smtpMailLoginId, smtpLoginPwd);
                    _logger.LogInformation("Authenticated");

                    if (!emailClient.IsConnected)
                    {
                        _logger.LogError("Email client is not connected");
                    }
                    else
                    {
                        _logger.LogInformation("Email client is connected");
                    }
                }

                bool mailSent = false;
                while (checkCheckForPendingMails)
                {
                    foreach (var mail in mails)
                    {
                        try
                        {
                            if (!emailClient.IsConnected)
                            {
                                checkCheckForPendingMails = false;
                                break;
                            }
                            mailSent = false;
                            var message = new MimeMessage();

                            message.From.Add(new MailboxAddress(smtpMailfromMailId, smtpMailfromMailId));


                            if (mail?.MailTo != null)
                            {
                                foreach (var mailTo in mail.MailTo.Split(";"))
                                {
                                    if (string.IsNullOrEmpty(mailTo.Trim()))
                                        continue;

                                    try
                                    {
                                        message.To.Add(new MailboxAddress(smtpMailfromMailId, mailTo));
                                    }
                                    catch (Exception ex)
                                    {
                                        _logger.LogError(mail.KeyId + " - " + mailTo + " could not be added to list. Reason - " + ex.Message);
                                    }
                                }

                                //message.To.AddRange(mail?.MailTo?.Split(";").Select(mailId => new MailboxAddress(mailId, mailId)));
                            }
                            if (mail?.MailBcc != null)
                            {
                                //message.Bcc.AddRange(mail?.MailBcc?.Split(";").Select(mailId => new MailboxAddress(mailId, mailId)));

                                foreach (var mailBcc in mail.MailBcc.Split(";"))
                                {
                                    if (string.IsNullOrEmpty(mailBcc.Trim()))
                                        continue;
                                    try
                                    {
                                        message.Bcc.Add(new MailboxAddress(smtpMailfromMailId, mailBcc));
                                    }
                                    catch (Exception ex)
                                    {
                                        _logger.LogError(mail.KeyId + " - " + mailBcc + " could not be added to list. Reason - " + ex.Message);
                                    }
                                }
                            }

                            if (mail?.MailCc != null)
                            {
                                //message.Bcc.AddRange(mail?.MailCc?.Split(";").Select(mailId => new MailboxAddress(mailId, mailId)));
                                foreach (var mailCC in mail.MailCc.Split(";"))
                                {
                                    if (string.IsNullOrEmpty(mailCC.Trim()))
                                        continue;
                                    try
                                    {
                                        message.Cc.Add(new MailboxAddress(smtpMailfromMailId, mailCC));
                                    }
                                    catch (Exception ex)
                                    {
                                        _logger.LogError(mail.KeyId + " - " + mailCC + " could not be added to list. Reason - " + ex.Message);
                                    }
                                }
                            }
                            if (!(message.Bcc.Count > 0 || message.To.Count > 0))
                            {
                                _logger.LogError(mail?.KeyId + "No valid recipients available.");

                                var dbResponse = await _mailQueueMailsRepository.UpdateFailure(new BaseSpTcmPL(),
                                    new ParameterSpTcmPL
                                    {
                                        PQueueKeyId = mail?.KeyId,
                                        PLogMessage = "No valid recipients available."
                                    }
                                    );

                                continue;
                            }

                            message.Subject = mail?.MailSubject;

                            string body = (mail?.MailBody1 ?? "" + mail?.MailBody2);

                            BodyBuilder bodyBuilder = new BodyBuilder();

                            if (mail?.MailType?.ToUpper() == "HTML")
                            {
                                bodyBuilder.HtmlBody = body;
                            }
                            else
                            {
                                bodyBuilder.TextBody = body;
                            }


                            string[] mailAttachmentsOsName = mail?.MailAttachmentsOsName?.Split(";");
                            string[] mailAttachmentsBusinessName = mail?.MailAttachmentsBusinessName?.Split(";");

                            for (int i = 0; i < mailAttachmentsOsName?.Length; i++)
                            {
                                string attachmentFilePath = Path.Combine(attachmentsRepository ?? string.Empty, mailAttachmentsOsName[i]);
                                if (File.Exists(attachmentFilePath))
                                    bodyBuilder.Attachments.Add(mailAttachmentsBusinessName?[i], System.IO.File.ReadAllBytes(attachmentFilePath));
                            }
                            message.Body = bodyBuilder.ToMessageBody();
                            await emailClient.SendAsync(message);
                            mailSent = true;


                        }
                        catch (SmtpCommandException ex)
                        {
                            _logger.LogError(ex?.Message?.ToString());
                            _logger.LogError(ex?.InnerException?.ToString());
                            if (!emailClient.IsConnected)
                            {
                                _logger.LogError("SMPT Client not connect");
                                checkCheckForPendingMails = false;
                                break;
                            }

                            var dbResponse = await _mailQueueMailsRepository.UpdateFailure(new BaseSpTcmPL(),
                                new ParameterSpTcmPL
                                {
                                    PQueueKeyId = mail.KeyId,
                                    PLogMessage = ex?.Message
                                }
                                );
                            if (dbResponse.PMessageType != "OK")
                            {

                                _logger.LogError("Error while updating success for mail queue with id " + mail.KeyId);
                            }
                        }
                        catch (Exception ex)
                        {
                            _logger.LogError(ex?.Message?.ToString());
                            _logger.LogError(ex?.InnerException?.ToString());
                        }
                        if (mailSent)
                        {
                            var response = await _mailQueueMailsRepository.UpdateSuccess(new BaseSpTcmPL(), new ParameterSpTcmPL { PQueueKeyId = mail?.KeyId });
                            if (response.PMessageType != "OK")
                            {
                                _logger.LogError("Error while updating success for mail queue with id " + mail?.KeyId);
                            }
                        }
                        await Task.Delay(TimeSpan.FromSeconds(smtpMailDelayInSeconds));
                    }
                    /*End of For Loop*/

                    pendingMails = await _mailQueueMailsTableListRepository.GetPendingMailsListAsync(new Models.BaseSpTcmPL(), new ParameterSpTcmPL { PRowNumber = 0, PPageLength = 100 });

                    mails = pendingMails ?? Enumerable.Empty<MailQueueModel>();


                    if (!mails.Any())
                    {
                        checkCheckForPendingMails = false;
                        break;
                    }
                    else
                    {
                        _logger.LogInformation("Pending Mails fetched - " + pendingMails?.Count());
                    }

                }
                /*End of while loop*/

            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message);
                _logger.LogError(ex?.InnerException?.ToString());
                _logger.LogError(ex?.Data.ToString());
                
                
            }
            emailClient.Disconnect(true);
            emailClient.Dispose();
        }
    }
}