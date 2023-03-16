import UIKit
import SnapKit

public protocol ImageViewerControllerDelegate: ImageLoader {
    func dismiss(_ imageViewerController: ImageViewerController, lastPageIndex: Int)
}

public extension ImageViewerControllerDelegate {
    func dismiss(_ imageViewerController: ImageViewerController, lastPageIndex: Int) {}
}

public final class ImageViewerController: UIViewController {

    lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        return scrollView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.addSubview(effectView)
        return imageView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    private lazy var dismissButton: UIButton = { [unowned self] in
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let image = UIImage(systemName: "multiply")!
            .withConfiguration(configuration)
        button.tintColor = .darkGray
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()

    private var pageIndex: Int
    private let imageURLs: [String]
    private var pageViews: [PageView] = []
    public weak var delegate: ImageViewerControllerDelegate?

    public init(imageURLs: [String], pageIndex: Int = 0) {
        self.pageIndex = pageIndex
        self.imageURLs = imageURLs
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        guard let imageLoader = delegate else {
            fatalError("must confirm ImageViewerControllerDelegate")
        }
        imageURLs.forEach { [weak self] url in
            let pageView = PageView(imageURL: url, imageLoader: imageLoader)
            pageView.pageViewDelegate = self
            self?.scrollView.addSubview(pageView)
            self?.pageViews.append(pageView)
        }
        
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        view.addSubview(pageControl)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setup layout
        scrollView.frame = view.bounds
        backgroundImageView.frame = view.bounds
        pageViews.enumerated().forEach { [unowned self] index, view in
            view.frame = self.scrollView.bounds
            view.frame.origin.x = self.scrollView.frame.width * CGFloat(index)
        }
        
        pageControl.frame = .init(
            x: (view.frame.width - 200) / 2,
            y: view.frame.height - 50,
            width: 200,
            height: 30
        )
        
        // configuration with initial values after initialize layout
        pageControl.numberOfPages = pageViews.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = pageIndex
//        pageControl.currentPageIndicatorTintColor = UIColor.Pallete.orange
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.isHidden = pageViews.count == 1
        scrollView.contentSize.width = CGFloat(pageViews.count) * scrollView.frame.width
        scrollView.setContentOffset(.init(x: scrollView.bounds.width * CGFloat(pageIndex), y: 0), animated: false)
        updateDynamicBackgroundImage()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismiss(self, lastPageIndex: pageIndex)
    }
    
    private func updateDynamicBackgroundImage() {
        /*
         Необходимо обновить backgroundImage в тот момент, когда завершены [Loading images in PageView] и [viewDidLayoutSubviews].
         Поскольку загрузка изображения в PageView происходит асинхронно, скорость ее завершения нестабильна.
         Поэтому, вызывая этот процесс в обоих местах, гарантируется, что он будет обновлен, когда оба завершатся.
         */
        UIView.animate(withDuration: 0.5) {
            self.backgroundImageView.image = self.pageViews[self.pageIndex].imageView.image
        }
    }
    
    @objc func dismissAction() {
        dismiss(animated: true)
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        updateDynamicBackgroundImage()
        pageControl.currentPage = pageIndex
    }
}

extension ImageViewerController: PageViewDelegate {
    func pageViewStatusDidChanged(_ status: PageView.Status) {
        scrollView.isScrollEnabled = status == .normal
    }
    
    func pageViewDidLoadImage() {
        updateDynamicBackgroundImage()
    }
}

// MARK: CustomTransition
extension ImageViewerController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(context: .present)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(context: .dismiss)
    }
}
