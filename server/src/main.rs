use tonic::{transport::Server, Request, Response, Status};

use api::api_service_server::{ApiService, ApiServiceServer};
use api::{EchoRequest, EchoResponse};

pub mod api {
  tonic::include_proto!("api");
}

#[derive(Debug, Default)]
pub struct Api {}

#[tonic::async_trait]
impl ApiService for Api {
  async fn echo(&self, request: Request<EchoRequest>) -> Result<Response<EchoResponse>, Status> {
    println!("Got a request: {:?}", request);

    let reply = EchoResponse {
      message: format!("{}", request.into_inner().message),
    };

    Ok(Response::new(reply))
  }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
  let addr = format!("{}:{}", "127.0.0.1", "3000").parse()?;

  println!("Server listening on {}", addr);

  Server::builder()
    .add_service(ApiServiceServer::new(Api::default()))
    .serve(addr)
    .await?;

  Ok(())
}
