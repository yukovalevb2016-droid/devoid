import os

import torch
import torchvision
from torchvision.models import MobileNet_V2_Weights
import coremltools as ct


def main() -> None:
    weights = MobileNet_V2_Weights.IMAGENET1K_V2
    model = torchvision.models.mobilenet_v2(weights=weights)
    model.eval()

    example = torch.rand(1, 3, 224, 224)
    traced = torch.jit.trace(model, example)

    mean = [0.485, 0.456, 0.406]
    std = [0.229, 0.224, 0.225]
    scale = [1.0 / (255.0 * s) for s in std]
    bias = [-m / s for m, s in zip(mean, std)]

    mlmodel = ct.convert(
        traced,
        inputs=[
            ct.ImageType(
                shape=(1, 3, 224, 224),
                scale=scale,
                bias=bias,
                color_layout="RGB",
            )
        ],
    )
    mlmodel.short_description = "FoodClassifier (MobileNetV2, ImageNet)"
    mlmodel.author = "coremltools"
    mlmodel.license = "Apache-2.0"

    out_dir = os.path.dirname(os.path.abspath(__file__))
    out_path = os.path.join(out_dir, "FoodClassifier.mlmodel")
    mlmodel.save(out_path)
    print("Saved model to", out_path)


if __name__ == "__main__":
    main()
