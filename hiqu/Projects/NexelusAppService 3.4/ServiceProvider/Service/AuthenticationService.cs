using NexelusApp.Service.DataAccess;
using NexelusApp.Service.Exceptions;
using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Service
{
    public class AuthenticationService<T> where T : EntityBase, new()
    {
        private NexContext context;
        public AuthenticationService(NexContext _context)
        {
            this.context = _context;
        }
        public Response<T> ValidateAuthenticationKey(CriteriaBase<T> criteria)
        {
            Response<T> response = new Response<T>();
            response.ResponseType = Enums.ResponseType.Success;
            try
            {
                Repository<T> resRepository = new Repository<T>(this.context);
                var dbResponse = resRepository.Select(criteria);
                if (dbResponse != null)
                {
                    response.Entities = dbResponse;
                }
            }
            catch (AppException ex)
            {
                response.ResponseType = Enums.ResponseType.GeneralError;
                response.Message = ex.Message;
            }
            catch (Exception ex)
            {
                response.ResponseType = Enums.ResponseType.GeneralError;
                response.Message = ex.Message;
            }
            return response;
        }

        public Response<T> GetLoginCredentials(CriteriaBase<T> criteria)
        {
            Response<T> response = new Response<T>();
            response.ResponseType = Enums.ResponseType.Success;
            try
            {
                Repository<T> resRepository = new Repository<T>(this.context);
                var dbResponse = resRepository.Select(criteria);
                if (dbResponse != null)
                {
                    response.Entities = dbResponse;
                }
            }
            catch (AppException ex)
            {
                response.ResponseType = Enums.ResponseType.GeneralError;
                response.Message = ex.Message;
            }
            catch (Exception ex)
            {
                response.ResponseType = Enums.ResponseType.GeneralError;
                response.Message = ex.Message;
            }
            
            return response;
        }
    }
}
