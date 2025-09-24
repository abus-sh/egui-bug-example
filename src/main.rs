use eframe::egui;

fn main() {
    env_logger::init();
    let native_options = eframe::NativeOptions::default();
    eframe::run_native(
        "Example App",
        native_options,
        Box::new(|_| Ok(Box::new(MyEguiApp::default()))),
    ).unwrap();
}

#[derive(Default)]
struct MyEguiApp {}

impl eframe::App for MyEguiApp {
   fn update(&mut self, ctx: &egui::Context, _: &mut eframe::Frame) {
       egui::CentralPanel::default().show(ctx, |ui| {
           ui.heading("Hello World!");
       });
   }
}