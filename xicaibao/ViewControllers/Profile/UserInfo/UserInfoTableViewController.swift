//
//  UserInfoTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/28.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
import Photos
import AlamofireImage
import MessageUI


class UserInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var avatarActivity: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var telLabel: UILabel!
    
    var user: User?
    
    // 上传照片
    lazy var alertController: UIAlertController = {
        var ac = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        // 相机 Action
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            
            switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
            // 允许访问
            case .authorized:
                self.cameraAction()
            // 未请求权限
            case .notDetermined:
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (status: Bool) -> Void in
                    if status {
                        self.cameraAction()
                    }
                })
            default:
                // 限制或拒绝
                self.fetchPermission("相机")
            }
        }
        
        // 相簿 Action
        let photosLibiaryAction = UIAlertAction(title: "选取照片", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
            switch PHPhotoLibrary.authorizationStatus() {
            // 允许访问
            case .authorized:
                self.libraryAction()
            // 未请求权限
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                    if status == .authorized {
                        self.libraryAction()
                    }
                })
            default:
                // 限制或拒绝
                self.fetchPermission("照片")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        ac.addAction(cameraAction)
        ac.addAction(photosLibiaryAction)
        ac.addAction(cancelAction)
        return ac
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        var ip = UIImagePickerController()
        ip.delegate = self
        ip.allowsEditing = true
        ip.navigationBar.barTintColor = UIColor.kThemeColor()
        ip.navigationBar.tintColor = UIColor.white
        ip.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        return ip
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private  func setupView() {
        photoImageView.layer.cornerRadius = photoImageView.layer.bounds.height / 2
        guard let user = self.user else { return }
        
        nameLabel.text = user.userName
        telLabel.text = user.userTel
        
        // 占位图
        let placeholderImage = UIImage(named: "wode_touxiang")
        
        if user.imageUrl != nil {
            let imageUrl = URL(string: user.imageUrl!)
            photoImageView.af_setImage(withURL: imageUrl!)
        } else {
            photoImageView.image = placeholderImage
        }
    }
    
    
    private func fetchPermission(_ mediaType: String) {
        let alertController = UIAlertController(title: "未允许访问\"\(mediaType)\"", message: "在\"设置\"中打开\"\(mediaType)\"来允许访问您的\(mediaType)", preferredStyle: UIAlertControllerStyle.alert)
        let confirmAction = UIAlertAction(title: "设置", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            UIApplication.shared.openURL(SystemPathHelper.kSystemSettingsPath)
        })
        let cancelAction = UIAlertAction(title: "好", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func libraryAction() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func cameraAction() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    // 上传照片，更新头像
    public func resizeImageAndUpload(_ image: UIImage) {
        avatarUploading()
        
        // 压缩图片
        let resizedImage = image.af_imageScaled(to: CGSize(width: 240.0, height: 240.0))
//        let resizedImage = image.resizedImage(byMagick: UserUpload.USER_PHOTO_RESIZE)
        
        guard let photoData = UIImageJPEGRepresentation(resizedImage, UserUpload.USER_UPLOAD_JPEG_RATIO) else { return }
        uploadAvatar(photoData)
    }
    
    private func avatarUploading() {
        photoImageView.isHidden = true
        avatarActivity.startAnimating()
    }
    
    private func avatarUploadFinished(_ imageUrl: String?) {
        photoImageView.isHidden = false
        avatarActivity.stopAnimating()
        guard let imageUrl = imageUrl
            else {
                let avatarPlaceholder = UIImage(named: "wode_touxiang")
                self.photoImageView.image = avatarPlaceholder
                return
        }
        
        let avatar = URL(string: imageUrl)!
        self.photoImageView.af_setImage(withURL: avatar)
    }
    
    // 照片上传到服务器
    private func uploadAvatar(_ photoData: Data) {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().patchProfilePhoto(photoData, uuid: uuid, token: token, successBlock: { (user) in
            
            self.avatarUploadFinished(user.imageUrl)
            
        }) { (error) in
            
            print("patchProfilePhoto error: \(error.localizedDescription)")
            self.avatarUploadFinished(nil)
            
            let alertController = UIAlertController(title: "", message: "头像上传失败，请稍后再试", preferredStyle: UIAlertControllerStyle.alert)
            let confirmAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func avatarAction() {
        self.present(self.alertController, animated: true, completion: nil)
    }
    
    
    // segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "nameVC" {
            if let editNameVC = segue.destination as? EditNameTableViewController {
                guard let user = self.user else { return }
                editNameVC.user = user
                editNameVC.delegate = self
            }
        }
    }

}

extension UserInfoTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 上传头像
        if indexPath.section == 0 {
            self.avatarAction()
        }
    }
}

extension UserInfoTableViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        resizeImageAndUpload(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UserInfoTableViewController: EditNameTableViewControllerDelegate {
    
    func editNameSave(name: String) {
        nameLabel.text = name
    }
}


// AvatarSize
struct UserUpload {
    static let USER_UPLOAD_JPEG_RATIO: CGFloat = 0.9
    static let USER_PHOTO_RESIZE = "240x240#"
}
