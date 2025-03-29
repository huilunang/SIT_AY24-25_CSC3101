# SIT_AY24-25_CSC3101

## Introduction
This project serves as a proof of concept for addressing the [issue of contaminated recyclables](https://www.nea.gov.sg/media/news/news/index/new-bloobin-ai-chatbot-to-help-public-recycle-right) in Singapore's recycling bins (Bloobin). Using the [YOLO11s-seg model](https://docs.ultralytics.com/tasks/segment/), it provides real-time feedback on the recyclability and cleanliness of items, aiming to reduce contamination. While the model is still in its early stages, with limited examples and not yet at optimal performance, this project demonstrates the potential to improve recycling habits through feedback and incentivized rewards. Further development is required to enhance accuracy and usability, but it lays the groundwork for a more effective recycling system.

## Demo
[![Watch the video](assets/video_thumbnail.jpg)](https://youtu.be/R1xNaUY6vA0)

## Running Application
### Dependencies
1. [Docker](https://www.docker.com/)
2. [Make](https://www.gnu.org/software/make/#download)  
   > Alternatively, use a package manager like Brew (Mac) or Chocolatey (Windows)

### Execution
1. Open Docker Desktop
2. Run the `make run` command in the terminal to start the backend and database servers
3. The application has been tested on iPhone 15, iOS version 18.3.2. Follow the deployment steps [here](https://docs.flutter.dev/platform-integration/ios/install-ios/install-ios-from-macos) to run the application

### Cleanup
1. Run the `make clean` command in the terminal to stop the backend and database servers

## Architecture
![Application Architecture](assets/architecture.png "Application Architecture")

The architecture follows a microservices model with three key servers:

- **Application Server** (Go): Handles API requests, business logic, and frontend-backend communication.
- **Model Server** (Python): Runs a deep-learning model for recycling material analysis and contamination detection.
- **Database Server** (PostgreSQL): Stores user profiles, recycling data, and contamination assessments.

All servers are containerized for scalability and maintainability, with a distributed design for load balancing and modular updates.

## Features
1. **Authentication**
   - Sign up
   - Sign in with JWT token

2. **Home**
   - Recycling effort chart (viewable weekly or monthly from the current date)
   - Points and rewards visualization

3. **Recycle**
   - Camera to capture recyclables
   - Prompt if the recyclable is not clean

4. **Points**
   - Show transactions related to points earned from recycling and claimed for vouchers
   - Two types of vouchers: one immediately claimable, the other claimable anytime before a 3-month expiration

5. **Rewards**
   - Vouchers that can be claimed later, before the 3-month expiration

## Resources
1. [Complete Backend API in Golang (JWT, MySQL & Tests)](https://www.youtube.com/watch?v=7VLmLOiQ3ck)
2. [How To Build A Complete JSON API In Golang (JWT, Postgres, and Docker) Part 1
](https://www.youtube.com/watch?v=pwZuNmAzaH8&t=597s)
3. [Organizing a Go module](https://go.dev/doc/modules/layout)
4. [Flutter Refresher Course](https://www.youtube.com/watch?v=HQ_ytw58tC4)
5. [Flutter documentation](https://docs.flutter.dev/)
6. [Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/)
7. [Flutter Clean Architecture](https://medium.com/@enesakbal00/flutter-clean-architecture-part-1-introduction-f5dadf1bf3ee)
8. [bloc State Management](https://bloclibrary.dev/)
9. [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/)
10. [How to label data for YOLOv8 Instance Segmentation training](https://roboflow.com/how-to-label/yolov8-segmentation)
11. [How to Train YOLOv11 Instance Segmentation on a Custom Dataset](https://blog.roboflow.com/train-yolov11-instance-segmentation/#train-yolo11-on-a-custom-dataset)
12. [Comprehensive Tutorials to Ultralytics YOLO](https://docs.ultralytics.com/guides/)
13. [Models Supported by Ultralytics](https://docs.ultralytics.com/models/)
14. [Efficient Hyperparameter Tuning with Ray Tune and YOLO11](https://docs.ultralytics.com/integrations/ray-tune/#basic-experiment-level-analysis)
15. [NEA's Recycling Search Engine](https://www.nea.gov.sg/recycling-search-engine/)
16. [NEA's Recycling Guide](https://www.nea.gov.sg/docs/default-source/our-services/waste-management/list-of-items-that-are-recyclable-and-not.pdf)
17. [Singapore's Recyclopedia](https://recyclopedia.sg/)

## Dataset
The contamination detection model is an image classifier based on deep learning, trained on a dataset specifically curated for Singapore's recycling practices. The [dataset](https://universe.roboflow.com/csc3101bloobin/csc3101_bloobin_dataset/dataset/3), collected through local photos and online sources, contains 1701 images across various categories after augmentations.

These images are categorized into [parent classes](bloobin_model/src/type_mapping.yaml) such as metal, plastic, glass, paper, cardboard, and non-recyclable materials, with the non-recyclable category including contaminants, silicone funnels, styrofoam, takeaway plastic containers, trash, and water.