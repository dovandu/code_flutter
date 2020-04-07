Cấu trúc và mô hình app:
```sh
assets : 
         - fonts
         - icons
         - jsons: config data
lib: 
     - base:
             + presenter: Tất cả các m hình đ phải có class presenter và đc kế ừa từ base
             + contract: abstract (void updateState();)
             + const
             + utils
             + data_store
             + api_client: Tất cả các m hình đ phải có class presenter và đc kế ừa từ base
     - model
     - core: 
             + api
             + api_config
     - helper
     - pages: cái view màn chính ( chi tiết screens)
     - screens: MVP
              + bloc (khi xử lý, update dữ liệu phức tạp)
              + model
              + views: nhiều view nhỏ thì tạo folder
              * example:
                        1. login_view: chỉ có view ko có biến
                        2. login_presenter: các biến + phương thức
                        3. login_api_client: xử lý request api
              * Lưu ý: 
                       1. Hàm ko đc viết trong view bao gồm cả builder item
                       2. item phải viết class riêng
                       3. Hạn chế tối đa việc tách class ko cần thiết
     - views: các view chung cho nếu trùng nhau
     - main.dart
```
      
